const router = require('express').Router()
const { register, loginOtp, sendOtpOnMail, verifyMailOtp, sendOtponMob, verifyMobOtp, verifyLoginOtp, refreshToken, logOutUser, adminLogin, adminRegister, getuserlist, addAdmin, getAllAdminUser } = require('../../controllers/auth-controller/authController')
const upload = require("../../middlewares/upload.middleware")

router.post("/sendmailOtp", sendOtpOnMail)
router.post("/verifyMailOtp", verifyMailOtp)
router.post("/sendmobOtp", sendOtponMob)
router.post("/verifymobOtp", verifyMobOtp)
router.post("/register", upload.single("profileImg"), register)
router.post('/sendloginOtp', loginOtp)
router.post('/verifyloginOtp', verifyLoginOtp)
router.get('/getAlluser',getuserlist)

router.post('/refresh-token', refreshToken)
router.post('/logout', logOutUser)

// admin apis

router.post('/admin/login',adminLogin)
router.post('/admin/registerAdmin',adminRegister)
router.post('/admin/addAdmin',addAdmin)
router.get('/admin/getAdminuser',getAllAdminUser)
// router.post('/admin/forget-password',forgetPassword)


module.exports = router