module.exports = {
    user_settings: {
        instance: {
            type: "string",
            default: "http://cloudtube-newleaf:3000"
        },
        save_history: {
            type: "boolean",
            default: false
        },
        local: {
            type: "boolean",
            default: false
        }
    },

    server_setup: {
        local_instance_origin: "http://cloudtube-newleaf:3000"
    },
}
