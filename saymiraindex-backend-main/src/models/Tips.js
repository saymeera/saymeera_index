const mongoose = require("mongoose")

const tips = new mongoose.Schema({
    tipsScript: {type:String, required:true},
    buySell:{type:String},
    stopLoss:{type:String},
    expiryUnit:{type:String},
    target:{type:String},
    tipsMsg:{type:String},
    status:{type:String,default:'Active'},
    createdBy:{type:mongoose.Schema.Types.ObjectId, ref:'adminUser',required: true},
    tipsPublishAt:{type:Date},
    expiryAt:{type:Date},
},{ timestamps: true })

module.exports = mongoose.model('Tips',tips)