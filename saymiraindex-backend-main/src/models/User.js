const mongoose = require('mongoose')

const userSchema = new mongoose.Schema({
  subtype: { type: String },
  isAdmin: { type: String, required: true },
  password:{type:String},
  userId: { type: String },
  fullName: { type: String, trim: true },
  corporateName: { type: String, trim: true },
  type: { type: String },
  email: { type: String, required: true, unique: true, lowercase: true, trim: true },
  mobile: { type: String, required: true, unique: true },
  profileImg: { type: String },
  gender: { type: String, required: true },
  country: { type: String },
  state: { type: String },
  district: { type: String },
  discountCode: { type: String },
  referralUserId: { type: String },
  brokerUserId: { type: String },
  brokerRegisteredAt: { type: Date },
  registeredAt: { type: Date, default: Date.now },
}, { timestamps: true })


module.exports = mongoose.model("User", userSchema)
