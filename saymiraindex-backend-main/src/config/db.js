const mongoose = require('mongoose');

module.exports = async () => {
    try {
        await mongoose.connect(process.env.MONGO_URI, {
            autoIndex: false,
        })
        console.log("Mongodb Connected Successfully");
    } catch (error) {
        console.error("DB Connection Failed", error);
        process.exit(1);
    }
}