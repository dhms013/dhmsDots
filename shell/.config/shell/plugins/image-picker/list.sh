#!/bin/bash

# Lists images from newline-separated dirs as TSV rows: <path>\t<thumbnail>.
# Generates cached 1536x864 JPEG thumbnails for anything missing (parallel,
# lock-guarded) so the picker never decodes full-resolution sources.

image_dirs=${1:-}
cache_dir=${XDG_CACHE_HOME:-$HOME/.cache}/dhms/image-selector
index_file="$cache_dir/index.tsv"

mkdir -p "$cache_dir"
touch "$index_file"

generate_thumbnail() {
  local image="$1"
  local thumbnail="$2"
  local lock="$thumbnail.lock"
  local lock_fd
  local tmp="$thumbnail.$$.jpg"

  exec {lock_fd}>"$lock" || return
  flock -w 60 "$lock_fd" || return

  # A generator killed mid-write leaves partial $thumbnail.<pid>.jpg behind;
  # only the lock holder writes these, so any found now are stale.
  rm -f "$thumbnail".*.jpg

  [[ -f $thumbnail ]] && return

  if MAGICK_THREAD_LIMIT=1 magick "$image" -auto-orient -resize '1536x864^' \
      -gravity center -extent 1536x864 -quality 82 -strip "$tmp" 2>/dev/null; then
    mv -f "$tmp" "$thumbnail"
  else
    rm -f "$tmp" "$thumbnail"
  fi
}

pending=$(mktemp)
trap 'rm -f "$pending"' EXIT

thumbnail_for() {
  local image="$1"
  local signature hash thumbnail

  signature=$(stat -Lc '%s:%Y' "$image") || return
  hash=$(awk -F '\t' -v path="$image" -v sig="$signature" '$1 == path && $2 == sig { print $3; exit }' "$index_file" 2>/dev/null)

  if [[ -z $hash ]]; then
    hash=$(printf '%s\t%s' "$image" "$signature" | md5sum | cut -d ' ' -f 1)
    printf '%s\t%s\t%s\n' "$image" "$signature" "$hash" >>"$index_file"
  fi

  thumbnail="$cache_dir/$hash.jpg"

  if [[ ! -f $thumbnail ]]; then
    printf '%s\0%s\0' "$image" "$thumbnail" >>"$pending"
    printf '%s' "$image"
    return
  fi

  printf '%s' "$thumbnail"
}

while IFS= read -r dir; do
  [[ -n $dir && -d $dir ]] || continue
  find -L "$dir" -maxdepth 1 -type f \
    \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.gif' -o -iname '*.bmp' -o -iname '*.webp' \) \
    -print0 2>/dev/null
done <<<"$image_dirs" | sort -z | while IFS= read -r -d '' image; do
  thumbnail=$(thumbnail_for "$image")
  [[ -n $thumbnail ]] || continue
  printf '%s\t%s\n' "$image" "$thumbnail"
done

# Generate every queued thumbnail at once; each magick stays single-threaded.
if [[ -s $pending ]]; then
  export -f generate_thumbnail
  xargs -a "$pending" -0 -n 2 -P "$(nproc)" \
    bash -c 'generate_thumbnail "$1" "$2"' _ >/dev/null 2>&1 || true
fi
