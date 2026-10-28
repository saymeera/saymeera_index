const ActivityLog = require("../../models/activityLog");
const loginActivity = require('../../models/loginHistory')
const {
    getDevice,
    getOS,
    getBrowser
} = require("../../utils/deviceInfo");

exports.logActivity = async ({
    req,
    userId,
    action,
    description = "",
    metadata = {}
}) => {
    try {
        ActivityLog.create({
            userId,
            action,
            description,
            ipAddress: req.ip,
            device: getDevice(req),
            os: getOS(req),
            browser: getBrowser(req),
            metadata
        });
    } catch (err) {
        console.error("Activity log failed:", err.message);
    }
}

exports.getloginActivity = async (req, res) => {
    try {
        console.log("getloginactivity", req.params.id)
        const userId = req.params.id
        const userloginActivity = await loginActivity.find({ userId: userId })
        res.status(200).json(userloginActivity)
    } catch (error) {
        res.status(500).json({ message: error.message })
    }
}

exports.getActivityLog = async (req, res) => {
    try {
        const userId = req.params.id
        const userActivitylog = await ActivityLog.find({ userId: userId })
        res.status(200).json(userActivitylog)
    } catch (error) {
        res.status(500).json({ message: error.message })
    }
}