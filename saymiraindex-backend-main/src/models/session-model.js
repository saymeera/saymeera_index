const mongoose = require('mongoose')

const session = new mongoose.Schema({
    refreshToken: { type: String },
    user: { type: mongoose.Schema.Types.ObjectId, ref: 'User' },
    device: { type: String },
    os: {type:String},
    browser: {type:String},

}, { timestamps: true })

module.exports = mongoose.model("session", session)