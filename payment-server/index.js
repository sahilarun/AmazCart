const express = require("express");
var app = express();
// This will make our form data much more useful
app.use(express.urlencoded({ extended: true }));
app.use(express.json());
const https = require('https')
const qs = require('querystring')
    // Middleware for body parsing
const parseUrl = express.urlencoded({ extended: false })
const parseJson = express.urlencoded({ extended: false })

const checksum_lib = require("./checksum");

const PaytmChecksum = require('paytmchecksum');

app.use((req, res, next) => {
    res.header("Access-Control-Allow-Origin", "*");
    res.header(
        "Access-Control-Allow-Headers",
        "Origin, X-Requested-With, Content-Type, Accept"
    );
    next();
});

const port = 3030;
const host = `http://flutter.rishfa.com`;
app.listen(port, () => {
    console.log(`Amazcart app listening on url -> ${host}:${port}`);
});

app.get('/', (req, res) => {
    res.send("Welcome to Amazcart app!");
});


// --- //
// STRIPE PAYMENT //
// --- //


const stripe = require('stripe')('sk_test_51JAWNlKS0igSTFP1HI5vdkzgiFppGHQpwnv4A9zCK4txMU5WcSmKRyIKlVdMtv9zlZFmmBaQ3O4vgvKjRjP3TJQv00jfbG5aTn'); // Add your Secret Key Here

app.post("/payment-intent", [parseUrl, parseJson], async(req, res) => {
    try {
        const paymentIntent = await stripe.paymentIntents.create({
            amount: req.query.amount,
            currency: req.query.currency,
            payment_method_types: ['card'],
            payment_method: req.query.payment_method_id,
            receipt_email: req.query.email,
        });
        res.json({ paymentIntent: paymentIntent });
    } catch (err) {
        res.status(400).json({ error: { message: err.message } })
    }
});


// --- //
// GPAY PAYMENT //
// --- //

app.post("/payment-intent-gpay", [parseUrl, parseJson], async(req, res) => {
    let paymentMethod = await stripe.paymentMethods.create({
        type: "card",
        card: {
            token: req.query.gpayToken
        }
    });
    try {
        const paymentIntent = await stripe.paymentIntents.create({
            amount: req.query.amount,
            currency: req.query.currency,
            capture_method: "automatic",
            payment_method: paymentMethod.id,
            receipt_email: req.query.email,
            confirm: true,
        });
        res.json({ paymentIntent: paymentIntent });
    } catch (err) {
        res.status(400).json({ error: { message: err.message } })
    }
});


// --- //
// MIDTRANS PAYMENT GATEWAY //
// --- //


const midtransClient = require('midtrans-client');

// Create Snap API instance

let snap = new midtransClient.Snap({
    // Set to true if you want Production Environment (accept real transaction).
    isProduction: false,
    serverKey: 'SB-Mid-server-vhZR3NSutmsNyM5SACGxH49V'
});

app.post('/create_midtrans_trxToken', [parseUrl, parseJson], (req, res) => {
    console.log(req.body);
    try {
        snap.createTransaction(req.body)
            .then((transaction) => {
                // transaction token
                let transactionToken = transaction.token;
                console.log('transactionToken:', transactionToken);
                res.json({
                    "token": transactionToken,
                    "redirect_url": transaction.redirect_url
                });
            });

    } catch (err) {
        res.status(400).json({ error: { message: err.message } })
    }
});

app.post('/check_midtrans_transaction', [parseUrl, parseJson], (req, res) => {
    console.log(req.query.trxID);
    try {
        snap.transaction.status(req.query.trxID)
            .then((statusResponse) => {
                let orderId = statusResponse.order_id;
                let transactionStatus = statusResponse.transaction_status;
                let fraudStatus = statusResponse.fraud_status;

                console.log(`Transaction notification received. Order ID: ${orderId}. Transaction status: ${transactionStatus}. Fraud status: ${fraudStatus}`);

                res.json({
                    "success": true,
                    "response": statusResponse,
                });
            }).catch((error) => {
                res.json({
                    "success": false,
                    "response": error.error,
                });
            });

    } catch (err) {
        res.json({
            "success": false,
            "error": snap.transaction.error,
        });
        res.status(400).json({ error: { message: err.message } })
    }
});



// --- //
// PayTM Payment Gateway //
// --- //

var PaytmConfig = {
    mid: "mmHPCS25768835616700",
    key: "&77cn6xIrDf#89TK",
    website: "WEBSTAGING"
};

var txn_url = "https://securegw-stage.paytm.in/order/process"; // for staging, for live use live credential

var callbackURL = `${host}:${port}/paymentReceipt`;

// app.post("/payment", (req, res) => {
//     console.log(req.body);
//     let paymentData = req.body;
//     var params = {};
//     params["MID"] = PaytmConfig.mid;
//     params["WEBSITE"] = PaytmConfig.website;
//     params["CHANNEL_ID"] = "WEB";
//     params["INDUSTRY_TYPE_ID"] = "Retail";
//     params["ORDER_ID"] = paymentData.orderID;
//     params["CUST_ID"] = paymentData.custID;
//     params["TXN_AMOUNT"] = paymentData.amount;
//     params["CALLBACK_URL"] = callbackURL;
//     params["EMAIL"] = paymentData.custEmail;
//     params["MOBILE_NO"] = paymentData.custPhone;

//     PaytmChecksum.genchecksum(params, PaytmConfig.key, (err, checksum) => {
//         if (err) {
//             console.log("Error: " + e);
//         }

//         var form_fields = "";
//         for (var x in params) {
//             form_fields +=
//                 "<input type='hidden' name='" + x + "' value='" + params[x] + "' >";
//         }
//         form_fields +=
//             "<input type='hidden' name='CHECKSUMHASH' value='" + checksum + "' >";

//         res.writeHead(200, { "Content-Type": "text/html" });
//         res.write(
//             '<html><head><title>Merchant Checkout Page</title></head><body><center><h1>Please do not refresh this page...</h1></center><form method="post" action="' +
//             txn_url +
//             '" name="f1">' +
//             form_fields +
//             '</form><script type="text/javascript">document.f1.submit();</script></body></html>'
//         );
//         res.end();
//     });
// });

app.post("/paymentReceipt", [parseUrl, parseJson], (req, res) => {
    let responseData = req.body;
    var checksumhash = responseData.CHECKSUMHASH;
    var result = checksum_lib.verifychecksum(
        responseData,
        PaytmConfig.key,
        checksumhash
    );
    if (result) {
        return res.send({
            status: 0,
            data: responseData
        });
    } else {
        return res.send({
            status: 1,
            data: responseData
        });
    }
});

app.post("/initiatePayTmTransaction", [parseUrl, parseJson], (req, res) => {

    console.log(req.body);

    var paytmParams = {};

    paytmParams.body = {
        "requestType": "Payment",
        "mid": PaytmConfig.mid,
        "websiteName": PaytmConfig.website,
        "orderId": req.body.orderId,
        "callbackUrl": req.body.callbackUrl,
        "txnAmount": {
            "value": req.body.amount,
            "currency": "INR",
        },
        "userInfo": {
            "custId": req.body.custID,
            "email": req.body.custEmail,
            "mobile": req.body.custPhone,
        },
    };

    /*
     * Generate checksum by parameters we have in body
     * Find your Merchant Key in your Paytm Dashboard at https://dashboard.paytm.com/next/apikeys 
     */
    PaytmChecksum.generateSignature(JSON.stringify(paytmParams.body), PaytmConfig.key).then(function(checksum) {

        paytmParams.head = {
            "signature": checksum
        };

        var post_data = JSON.stringify(paytmParams);

        var options = {

            /* for Staging */
            hostname: 'securegw-stage.paytm.in',

            /* for Production */
            // hostname: 'securegw.paytm.in',

            port: 443,
            path: `/theia/api/v1/initiateTransaction?mid=${PaytmConfig.mid}&orderId=${req.body.orderId}`,
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'Content-Length': post_data.length
            }
        };

        var response = "";
        var post_req = https.request(options, function(post_res) {
            post_res.on('data', function(chunk) {
                response += chunk;
            });

            post_res.on('end', function() {
                console.log('Response: ', response);

                let returnJson = {};
                returnJson.body = {
                    response
                }
                return res.send({
                    returnJson
                });
            });
        });

        post_req.write(post_data);
        post_req.end();
    });


});



// Future Code Goes Here