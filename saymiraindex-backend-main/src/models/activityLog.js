const mongoose = require("mongoose");

const activityLogSchema = new mongoose.Schema({
    userId: {
        type: mongoose.Schema.Types.ObjectId,
        ref: "User",
        required: true
    },

    action: {
        type: String,
        required: true
    },

    description: String,

    ipAddress: String,
    device: String,
    os: String,
    browser: String,

    metadata: {
        type: Object
    }

}, { timestamps: true });

module.exports = mongoose.model("activityLog", activityLogSchema);
