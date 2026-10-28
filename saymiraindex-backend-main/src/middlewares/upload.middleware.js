const multer = require("multer")
const path = require('path')
const { v4: uuid } = require("uuid");


// this functoion will be change for the peroduction on aws s3bucket
const storage = multer.diskStorage({
    destination: (req, file, cb) => {
        cb(null, "upload/profile")
    },
    filename: (req, file, cb) => {
        const ext = path.extname(file.originalname);
        cb(null, `${uuid()}${ext}`);
    }
})

const fileFilter = (req, file, cb) => {
    const allowed = ["image/jpeg", "image/png", "image/jpg"];
    allowed.includes(file.mimetype)
        ? cb(null, true)
        : cb(new Error("Only images allowed"));

}

const upload = multer({
    storage,
    limits: { fileSize: 2 * 1024 * 1024 }, // 2MB
    fileFilter
})

module.exports = upload;