const User = require('../../models/User')
const EmailOtp = require("../../models/emailOtp")
const MobileOtp = require("../../models/mobileOtp")
const LoginOtp = require("../../models/loginOtp")
const generateOtp = require('../../utils/generateOtp')
const LoginHistory = require('../../models/loginHistory')
const session = require('../../models/session-model')
const adminUser = require('../../models/adminUsers')
const { sendOtpEmail, sendOtpEmailforLogin } = require("../../services/email.service")
const smsService = require("../../services/sms.service")
const { generateAccessToken, generateRefreshToken } = require("../../utils/token")
const { getDevice, getBrowser, getOS } = require('../../utils/deviceInfo')
const verifyCaptcha = require("../../utils/verifyCaptcha");
const bcrypt = require("bcryptjs")
const jwt = require("jsonwebtoken")



exports.sendOtpOnMail = async (req, res) => {
    try {
        const { email } = req.body
        const otp = generateOtp();
        const hashedOtp = await bcrypt.hash(otp, 10);
        await EmailOtp.findOneAndDelete({ email });
        await EmailOtp.create({
            email,
            otp: hashedOtp,
            expiresAt: new Date(Date.now() + 5 * 60 * 1000)
        });
        await sendOtpEmail(email, otp);
        res.json({ message: "OTP sent to email", status: true });
    } catch (error) {
        res.status(500).json({ error: error.message, status: false })
    }
}

exports.verifyMailOtp = async (req, res) => {
    try {
        const { email, otp } = req.body;
        const record = await EmailOtp.findOne({ email });
        if (!record) {
            return res.status(400).json({ message: "OTP expired or invalid", status: false });
        }
        const isMatch = await bcrypt.compare(otp, record.otp);
        if (!isMatch) {
            return res.status(400).json({ message: "Invalid OTP", status: false });
        }

        await EmailOtp.deleteOne({ email });

        res.json({ message: "Email verified successfully", status: true });
    } catch (error) {
        res.status(500).json({ error: error.message, status: false })
    }
}

exports.sendOtponMob = async (req, res) => {
    try {
        const { mobile } = req.body
        const otp = generateOtp()
        const hashedOtp = await bcrypt.hash(otp, 10)
        await MobileOtp.findOneAndDelete({ mobile })
        await MobileOtp.create({
            mobile,
            otp: hashedOtp,
            expiresAt: new Date(Date.now() + 5 * 60 * 1000)
        })
        await smsService.sendLoginMobileOtp(mobile, otp);
        res.json({ message: "OTP sent to mobile", status: true });
    } catch (error) {
        res.status(500).json({ error: error.message, status: false });
    }
}

exports.verifyMobOtp = async (req, res) => {
    try {
        const { mobile, otp } = req.body;
        const record = await MobileOtp.findOne({ mobile });
        if (!record) {
            return res.status(400).json({ message: "OTP expired or invalid", status: false });
        }

        const isMatch = await bcrypt.compare(otp, record.otp);
        if (!isMatch) {
            return res.status(400).json({ message: "Invalid OTP", status: false });
        }
        await MobileOtp.deleteOne({ mobile });

        res.json({ message: "Mobile number verified", status: true });
    } catch (error) {
        res.status(500).json({ error: error.message, status: false });
    }
}

exports.register = async (req, res) => {
    try {
        const { subtype, userId, fullName, email, mobile, gender, discountCode, referralUserId, isAdmin, brokerUserId, brokerRegisteredAt, registeredAt, corporateName, type } = req.body
        const userExist = await User.findOne({ $or: [{ email: email }, { mobile: mobile }] })
        if (userExist) {
            return res.status(400).json({ message: "User already exists", status: false })
        }
        let imagePath
        if (req.file) {
            imagePath = `/upload/profile/${req.file.filename}`;
        }
        const user = await User.create({
            subtype,
            isAdmin: 'User',
            userId, //optional think about it 
            fullName,
            corporateName,
            type,
            email,
            mobile,
            profileImg: imagePath,
            gender,
            discountCode,
            referralUserId,
            brokerUserId,
            brokerRegisteredAt,
            registeredAt
        })
        res.status(201).json({ message: "User registered successfully", status: true })
    } catch (error) {
        res.status(500).json({ error: error.message, status: false })
    }
}

exports.loginOtp = async (req, res) => {
    try {
        const { email, mobile } = req.body
        if (!email && !mobile) {
            return res.status(400).json({ message: "Email or mobile required", status: false });
        }
        const identifier = email || mobile;
        const type = email ? "email" : "mobile";
        const user = await User.findOne({
            $or: [{ email }, { mobile }]
        });
        if (!user) {
            return res.status(404).json({ message: "User not found", status: false });
        }
        const otp = generateOtp();
        const hashedOtp = await bcrypt.hash(otp, 10);
        await LoginOtp.findOneAndDelete({ identifier });

        await LoginOtp.create({
            identifier,
            type,
            otp: hashedOtp,
            expiresAt: new Date(Date.now() + 5 * 60 * 1000)
        });
        if (type === "email") {
            await sendOtpEmailforLogin(email, otp);
        } else {
            // const mobile = "91" + user.mobile;
            await smsService.sendLoginMobileOtp(mobile, otp);
        }
        res.json({ message: "OTP sent successfully", status: true });

    } catch (error) {
        res.status(500).json({ error: error.message, status: false })
    }
}

exports.verifyLoginOtp = async (req, res) => {
    try {
        const { email, mobile, otp } = req.body;
        if (!otp) {
            return res.status(400).json({ message: "OTP required", status: false });
        }
        const identifier = email || mobile;

        const otpRecord = await LoginOtp.findOne({ identifier });
        if (!otpRecord) {
            return res.status(400).json({ message: "OTP expired or invalid", status: false });
        }
        // const isMatch = await bcrypt.compare(otp, otpRecord.otp);
        // if (!isMatch) {
        //     return res.status(400).json({ message: "Invalid OTP", status: false });
        // }
        const user = await User.findOne({
            $or: [{ email }, { mobile }]
        });
        if (!user) {
            return res.status(404).json({ message: "User not found", status: false });
        }

        await LoginOtp.deleteOne({ identifier });

        const accessToken = generateAccessToken(user._id);
        const refreshToken = generateRefreshToken(user._id);
        await session.create({
            refreshToken: refreshToken,
            user: user._id,
            device: getDevice(req),
            os: getOS(req),
            browser: getBrowser(req)
        })
        await LoginHistory.create({
            userId: user._id,
            ipAddress: req.ip,
            userAgent: req.headers["user-agent"],
            device: getDevice(req),
            os: getOS(req),
            browser: getBrowser(req),
        });

        res.json({
            message: "Login successful",
            accessToken,
            refreshToken,
            userId: user._id,
            status: true
        });

    } catch (error) {
        res.status(500).json({ error: error.message, status: true });
    }
}

exports.refreshToken = async (req, res) => {
    try {
        const { refreshToken } = req.body;
        if (!refreshToken) return res.sendStatus(401);
        const user = await User.findOne({
            "refreshTokens.token": refreshToken
        });
        if (!user) return res.sendStatus(403);

        jwt.verify(
            refreshToken,
            process.env.REFRESH_TOKEN_SECRET,
            async (err, decoded) => {
                if (err) return res.sendStatus(403);

                user.refreshTokens = user.refreshTokens.filter(
                    (rt) => rt.token !== refreshToken
                );

                const newAccessToken = generateAccessToken(user._id);
                const newRefreshToken = generateRefreshToken(user._id);

                user.refreshTokens.push({ token: newRefreshToken });
                await user.save();

                res.json({
                    accessToken: newAccessToken,
                    refreshToken: newRefreshToken,
                    status: true
                });
            }
        )
    } catch (error) {
        res.status(500).json({ error: error.message, status: false });
    }
}

exports.logOutUser = async (req, res) => {
    try {
        const refreshToken = req.body.refreshToken;

        const deleteSession = await session.findOneAndDelete({
            refreshToken: refreshToken
        })
        if (!deleteSession) {
            return res.status(400).json({
                message: 'Session already expired or invalid',
                status: false
            });
        }

        res.json({ message: "Logged out successfully", status: true });
    } catch (error) {
        res.status(500).json({ error: error.message, status: false });

    }

}

exports.getuserlist = async (req,res) =>{
    try {
        let Alluser = await User.find({}) 
        res.json({ message: "User list",userlist:Alluser, status: true });
    } catch (error) {
        res.status(500).json({ error: error.message, status: false });

    }
}

// admin Routing

exports.adminRegister = async (req, res) => {
    try {
        console.log(req.body,"req.body")
        const { fullName, email, mobile, gender, password } = req.body
        const userExist = await User.findOne({ email: email })
        if (userExist) {
            return res.status(400).json({ message: "User already exists", status: false })
        }
        const hashedPassword = await bcrypt.hash(password, 10);
        const user = await User.create({
            isAdmin: 'Admin',
            fullName,
            email,
            mobile,
            gender,
            password:hashedPassword
        })
        res.status(201).json({ message: "Admin registered successfully", status: true })
    } catch (error) {
        res.status(500).json({ error: error.message, status: true });
    }
}

exports.adminLogin = async (req, res) => {
    try {
        const { email, password, captchaToken } = req.body
        // const captchaRes = await verifyCaptcha(captchaToken);
        if (!email && !password) {
            return res.status(400).json({ message: "Emai & Password is required", status: false });
        }
        // console.log(email, password,"email, password,email, password,email, password,")
        const Admin = await adminUser.findOne({ email: email, isActive: true });
        if (!Admin) {
            return res.status(404).json({ message: "Admin not found", status: false });
        }
        if(!Admin.isActive){
            return res.status(200).json({ message: "your Account is Deactivated", status: false });
        }
        const isMatch = await bcrypt.compare(password, Admin.password);
        if (!isMatch) {
            return res.status(400).json({ message: "Invalid Email & Password", status: false });
        }
        const accessToken = jwt.sign({ id: Admin._id, role:Admin.role, permissions:Admin.permissions }, process.env.ADMIN_JWT_ACCESS_SECRET, { expiresIn: process.env.ADMIN_ACCESS_TOKEN_EXPIRY })

        res.json({
            message: "Login successful",
            accessToken,
            userId: Admin._id,
            status: true
        });

    } catch (error) {
        res.status(500).json({ error: error.message, status: true });
    }
}

exports.addAdmin = async (req, res) => {
    try {
        console.log(req.body,"req.body")
        const { fullName, email,password, role,permissions, mobile,isActive } = req.body
        const userExist = await adminUser.findOne({ email: email })
        if (userExist) {
            return res.status(400).json({ message: "User already exists", status: false })
        }
        const hashedPassword = await bcrypt.hash(password, 10);
        const user = await adminUser.create({
            fullName,
            email,
            mobile,
            role,
            permissions,
            isActive,
            password:hashedPassword
        })
        res.status(201).json({ message: "Admin registered successfully", status: true })
    } catch (error) {
        res.status(500).json({ error: error.message, status: true });
    }
}

exports.getAllAdminUser = async (req, res)=>{
    try {
        let data = await adminUser.find({})
        res.status(201).json({message: "getting adminUser list successfully", data:data})
    } catch (error) {
        res.status(500).json({ error: error.message, status: true });
    }
}