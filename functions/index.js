const functions = require("firebase-functions");
const admin = require("firebase-admin");
const nodemailer = require("nodemailer");
const cors = require("cors")({origin: true});

admin.initializeApp();

const senderMail = "subhadeepchowdhury41@gmail.com";
const senderPass = "allaboutscience123";

exports.newOrder = functions.firestore.document("/orders/{documentID}")
    .onCreate(
        (snap, context) => {
          const order = snap.data();
          functions.logger.log("Creating a new order",
              context.params.documentID, order);
          return snap.ref.set({order});
        }
    );

// exports.newUser = functions.auth.user
//     .onCreate(
//         (snap, context) => {
//           const userId = snap.data();
//           functions.logger.log("New user joined",
//               context.params.documentID, userId);
//           return snap.ref.set({userId});
//         }
//     );

const transporter = nodemailer.createTransport({
  service: "gmail",
  auth: {
    user: senderMail,
    pass: senderPass,
  },
});

exports.sendMail = functions.https.onRequest((req, res) => {
  cors(req, res, () => {
    const dest = req.query.dest;
    const mailOptions = {
      from: "Subhadeep Chowdhury",
      to: dest,
      subject: "Null",
      html: `<p style="font-size: 16px;">Pickle Riiiiiiiiiiiiiiiick!!</p>
            <br />
            <img src="https://images.prod.meredith.com/product/fc8754735c8a9b4aebb786278e7265a5/1538025388228/l/rick-and-morty-pickle-rick-sticker" />
        `,
    };
    return transporter.sendMail(mailOptions, (erro, info) => {
      if (erro) {
        return res.send(erro.toString());
      }
      return res.send("Sended");
    });
  });
});
