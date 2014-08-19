# Description
#   A Hubot script that respond fuga or poyo
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot fuga - respond fuga or poyo
#
# Author:
#   bouzuya <m@bouzuya.net>
#
module.exports = (robot) ->
  robot.respond /fuga$/i, (res) ->
    FUGA_POYO_P = 0.01
    POYO_P = 0.1 + FUGA_POYO_P
    r = Math.random()
    fuga = if r <= FUGA_POYO_P
      'fugapoyo'
    else if r <= POYO_P
      'poyo'
    else
      'fuga'
    res.send fuga
