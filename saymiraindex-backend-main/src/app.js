const express = require('express')
const cors = require('cors')
const path = require("path");
const useragent = require("express-useragent");
const app = express();

app.use(cors())
app.use(express.json())
app.use(useragent.express());

app.use("/upload",express.static(path.join(__dirname,"../upload")))

app.use('/api/auth', require('./routes/auth-router/auth'))
app.use('/api/profile', require('./routes/profile-router/profileRouter'))
app.use('/api/activity', require('./routes/activity-router/activitylogRouter'))

//admin quiz Apis
app.use('/api/admin', require('./routes/Quiz-router/quizRouter'))

//user quiz Apis
app.use('/api/user', require('./routes/Quiz-router/quizRouter'))

//admin tips Apis
app.use('/api/admin/tips', require('./routes/tips-router/tipsRouter'))






// app.use(require("./middlewares/error.middleware"))






module.exports = app
