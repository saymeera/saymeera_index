exports.getDevice = (req) => {
    if (req.useragent?.isMobile) return "Mobile";
    if (req.useragent?.isTablet) return "Tablet";
    return "Desktop";
}

exports.getOS = (req) => {
    return req.useragent?.os || "Unknown";
};

exports.getBrowser = (req) => {
    return req.useragent?.browser || "Unknown";
};