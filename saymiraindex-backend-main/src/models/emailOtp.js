const mongoose = require('mongoose')

const emailOtp = mongoose.Schema({
    email: { type: String, required: true, index: true },
    otp: { type: String, required: true }, // hashed OTP
    expiresAt: { type: Date, required: true }
}, { timestamps: true });

emailOtp.index({ expiresAt: 1 }, { expireAfterSeconds: 0 })


module.exports = mongoose.model("emailOtp", emailOtp);