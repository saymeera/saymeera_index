const { SNSClient, PublishCommand } = require("@aws-sdk/client-sns");
const axios = require("axios");

const sendSms = async ({mobile, message}) => {
  try {
    const response = await axios.get(process.env.SMS_BASE_URL, {
      params: {
        username: process.env.SMS_USERNAME,
        apikey: process.env.SMS_API_KEY,
        apirequest: "Text",
        sender: process.env.SMS_SENDER_ID,
        mobile,
        message,
        route: process.env.SMS_ROUTE,
        TemplateID: process.env.SMS_TEMPLATE_ID,
        format: process.env.SMS_FORMAT,
        entityid: process.env.SMS_ENTITY_ID
      }
    })
    console.log(response.data,"response.data")
    return response.data
  } catch (error) {
    throw error;
  }
}


sendMobileOtp = async (mobile, otp) => {
  const message = `Welcome to Say Mira Index!  Your Log-in OTP is ${otp} Same has been sent to your email`
  return sendSms({ mobile, message });
};

sendLoginMobileOtp = async (mobile, otp) => {
  const message = `Thanks for contacting Say Mira Index! Your Log-in OTP is ${otp} Same has been sent to your email ${otp} SMIRAX`
  return sendSms({ mobile, message });
};


//this is for SES AWS
// const sns = new SNSClient({
//   region: process.env.AWS_REGION,
//   credentials: {
//     accessKeyId: process.env.AWS_ACCESS_KEY_ID,
//     secretAccessKey: process.env.AWS_SECRET_ACCESS_KEY
//   }
// });

//this is for SES AWS
// exports.sendMobileOtp = async (mobile, otp) => {
//   const message = `Your OTP is ${otp}. Valid for 5 minutes.`;

//   const command = new PublishCommand({
//     Message: message,
//     PhoneNumber: mobile // +91XXXXXXXXXX
//   });

//   await sns.send(command);
// };

//this is for SES AWS
// exports.sendloginMobileOtp = async (mobile, otp) => {
//   const message = `Your Login OTP is ${otp}. Valid for 5 minutes.`;

//   const command = new PublishCommand({
//     Message: message,
//     PhoneNumber: mobile // +91XXXXXXXXXX
//   });

//   await sns.send(command);
// };


module.exports = {
  sendMobileOtp,
  sendLoginMobileOtp
}