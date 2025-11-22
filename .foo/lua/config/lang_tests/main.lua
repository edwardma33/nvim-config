function Greet(name)
  print(string.format("Hello %s", name))
end

while true do
  io.write("Whats your name?: ")

  local name = io.read()

  if name == "q" then
    print("Goodbye")
    break
  end

  Greet(name)
end
