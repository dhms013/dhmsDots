// Match only arithmetic tokens, then parse by precedence. No JS evaluation.
function evaluate(expression) {
  if (!expression.trim() || expression.length > 256) return null

  var tokens = []
  var tokenizer = /\s+|(?:[0-9]+(?:\.[0-9]*)?|\.[0-9]+)|\*\*|[()+*/%\-]|[^\s]/g
  var number = /^(?:[0-9]+(?:\.[0-9]*)?|\.[0-9]+)$/
  var match
  while ((match = tokenizer.exec(expression)) !== null) {
    if (!/^\s+$/.test(match[0])) tokens.push(match[0])
  }

  var index = 0
  function take(token) {
    if (tokens[index] !== token) return false
    index++
    return true
  }

  function finite(value) {
    if (!Number.isFinite(value)) throw new Error("Non-finite result")
    return value
  }

  function primary() {
    if (take("(")) {
      var value = sum()
      if (!take(")")) throw new Error("Expected closing parenthesis")
      return value
    }
    var token = tokens[index++]
    if (!number.test(token)) throw new Error("Expected a number")
    return finite(Number(token))
  }

  function signedPower() {
    if (take("+")) return signedPower()
    if (take("-")) return -signedPower()
    var base = primary()
    return take("**") ? finite(Math.pow(base, signedPower())) : base
  }

  function product() {
    var value = signedPower()
    while (true) {
      if (take("*")) value = finite(value * signedPower())
      else if (take("/")) value = finite(value / signedPower())
      else if (take("%")) value = finite(value % signedPower())
      else return value
    }
  }

  function sum() {
    var value = product()
    while (true) {
      if (take("+")) value = finite(value + product())
      else if (take("-")) value = finite(value - product())
      else return value
    }
  }

  try {
    var result = sum()
    return index === tokens.length ? String(result) : null
  } catch (_) {
    return null
  }
}
