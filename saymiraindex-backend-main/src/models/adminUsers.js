const mongoose = require('mongoose')

const adminuserSchema = new mongoose.Schema({
  role: { type: String, required: true },
  permissions:{type:Array, required:true},
  password:{type:String},
  fullName: { type: String, trim: true },
  email: { type: String, required: true, unique: true, lowercase: true, trim: true },
  mobile: { type: String, required: true, unique: true },
  profileImg: { type: String },
  isActive: { type: Boolean, required: true },
}, { timestamps: true })


module.exports = mongoose.model("adminUser", adminuserSchema)
