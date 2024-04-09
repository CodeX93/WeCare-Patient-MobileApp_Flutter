const express = require("express");
const cors = require("cors");

require("dotenv").config();

const stripe = require("stripe")(process.env.stripe_secret_key);
const app = express();
app.use(cors());
const port = process.env.port || 4000;
app.use(express.json());

app.post("/create-payment-intent", async (req, res) => {
  try {
    const { amount, currency } = req.body;
    const paymentIntent = await stripe.paymentIntents.create({
      amount,
      currency,
    });

    if (!paymentIntent.client_secret) {
      throw new Error("Payment Intent does not contain client secret.");
    }

    console.log("Client secret:", paymentIntent.client_secret);

    res.send({ clientSecret: paymentIntent.client_secret });
  } catch (error) {
    console.error("Error creating Payment Intent:", error.message);
    res.status(500).send({ error: error.message });
  }
});

app.listen(port, () => {
  console.log(`Stripe server is running at http://localhost:${port}`);
});
