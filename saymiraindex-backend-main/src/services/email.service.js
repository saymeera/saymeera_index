const nodemailer = require("nodemailer")

const transporter = nodemailer.createTransport({
    host: process.env.SMTP_HOST,
    port: Number(process.env.MAIL_PORT),
    secure: false,
    auth: {
        user: process.env.SMTP_USER,
        pass: process.env.SMTP_PASS
    }
})


exports.sendOtpEmail = async (email, otp) => {
    await transporter.sendMail({
        from: `"SayMira App" <${process.env.SMTP_USER}>`,
        to: email,
        subject: "Verify your email",
        html: `
      <h3>Email Verification</h3>
      <p>Your OTP is:</p>
      <h2>${otp}</h2>
      <p>Valid for 5 minutes</p>
    `
    })
}

exports.sendOtpEmailforLogin = async (email, otp) => {
    await transporter.sendMail({
        from: `"SayMira App" <${process.env.SMTP_USER}>`,
        to: email,
        subject: "Verify your email",
        html: `
      <h3>For login enter your Otp</h3>
      <p>Your OTP is:</p>
      <h2>${otp}</h2>
      <p>Valid for 5 minutes</p>
    `
    })
}

