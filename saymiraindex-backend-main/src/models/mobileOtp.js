const mongoose = require("mongoose")

const mobileOtpSchema = new mongoose.Schema({
    mobile: { type: String, required: true, index: true },
    otp: { type: String, required: true },
    expiresAt: { type: Date, required: true }
}, { timestamps: true })

mobileOtpSchema.index({ expiresAt: 1 }, { expireAfterSeconds: 0 });

module.exports = mongoose.model("mobileOtp", mobileOtpSchema);
