black = {0, 0, 0, 1}
white = {1, 1, 1, 1}
red = {1, 0, 0, 1}
green = {0, 1, 0, 1}
blue = {0, 0, 1, 1}
yellow = {1, 1, 0, 1}
magenta = {1, 0, 1, 1}
cyan = {0, 1, 1, 1}

function setBlack()	love.graphics.setColor(unpack(black)) end
function setWhite() love.graphics.setColor(unpack(white)) end
function setRed() love.graphics.setColor(unpack(red)) end
function setGreen() love.graphics.setColor(unpack(green)) end
function setBlue() love.graphics.setColor(unpack(blue)) end
function setYellow() love.graphics.setColor(unpack(yellow)) end
function setMagenta() love.graphics.setColor(unpack(magenta)) end
function setCyan() love.graphics.setColor(unpack(cyan)) end
function setGrey(v) love.graphics.setColor(v, v, v, 1) end