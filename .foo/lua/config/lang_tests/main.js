const then = Date.setFullYear(2025, 11, 20);
then.toString()
const now = new Date();

while (true) {
  console.log("hello")
}


const user = {
  name: "maddox",
  age: 21,
  premium_til: Date.parse(then),
};

const isPremium = user.premium_til >= Date.parse(now);
console.log(`User: ${user.premium_til} | Today: ${Date.parse(now)}`)

if (isPremium) {
  console.log("PREMIUM");
} else {
  console.log("PEASANT");
}
