const functions = require("firebase-functions");
const stripe = require('stripe')(functions.config().stripe.testkey);

const generateResponse = function(intent) {
  switch(intent.status) { // Switch on the status of the intent
    case 'requires_action':
      return {
        clientSecret: intent.clientSecret,
        requiresAction: true,
        status: intent.status
      };
    case 'requires_payment_method':
      return { error: 'Your card was denied, please provide a new payment method' }; // Corrected key-value pair syntax
    case 'succeeded':
      console.log('Payment succeeded');
      return { clientSecret: intent.clientSecret, status: intent.status }; // Corrected key-value pair syntax
    default:
      return { error: 'Failed' }; // Default case to handle unexpected statuses
  }
};

exports.StripePayEndpointMethodId = functions.https.onRequest(async (req, res) => {
  const { paymentMethodId, items, currency, useStripeSdk, amount } = req.body;

  // Validate the amount received from the frontend
  if (!amount || typeof amount !== 'number') {
    return res.status(400).send({ error: 'Invalid amount provided' });
  }

  try {
    if (paymentMethodId) {
      const params = {
        amount: amount, // Use the amount passed from the frontend
        confirm: true,
        confirmation_method: 'manual',
        currency: currency,
        payment_method: paymentMethodId,
        use_stripe_sdk: useStripeSdk,
      };
      const intent = await stripe.paymentIntents.create(params);
      console.log(`Intent: ${intent}`);
      return res.send(generateResponse(intent));
    }
    return res.sendStatus(400);
  } catch (e) {
    return res.status(500).send({ error: e.message });
  }
});


exports.StripePayEndpointIntentId = functions.https.onRequest(async (req, res) => {
  const { paymentIntentId } = req.body;
  try {
    if (paymentIntentId) {
      const intent = await stripe.paymentIntents.confirm(paymentIntentId);
      res.send(generateResponse(intent));
    } else {
      res.sendStatus(400); // Moved inside else block to prevent sending response twice
    }
  } catch (e) {
    res.send({ error: e.message });
  }
});

// Assume calculateOrderAmount is a function you've defined to calculate the total amount based on the items.

