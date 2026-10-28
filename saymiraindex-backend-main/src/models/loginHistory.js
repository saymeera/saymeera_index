const mongoose = require('mongoose')

const loginHistory = new mongoose.Schema({
    userId: {
        type: mongoose.Schema.Types.ObjectId,
        ref: "User",
        required: true
    },

    loginAt: {
        type: Date,
        default: Date.now
    },

    logoutAt: {
        type: Date
    },

    ipAddress: String,
    userAgent: String,

    device: {
        type: String, // Mobile / Desktop / Tablet
    },

    os: String,
    browser: String,

    network: {
        type: String // Wifi / Mobile Data / Unknown
    },

    isActive: {
        type: Boolean,
        default: true
    }

}, { timestamps: true });

module.exports = mongoose.model('loginHistory', loginHistory)