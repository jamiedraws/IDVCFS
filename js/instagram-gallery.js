(function (global) {
    if ("app" in global) {
        const instantToken = Object.create({
            setEndpoint: function (credentials) {
                let endpoint =
                    "https://ig.instant-tokens.com/users/{user-id}/instagram/{instagram-id}/token?userSecret={user-secret}";

                endpoint = endpoint.replace("{user-id}", credentials.userId);
                endpoint = endpoint.replace(
                    "{instagram-id}",
                    credentials.instagramId
                );
                endpoint = endpoint.replace(
                    "{user-secret}",
                    credentials.userSecret
                );

                return endpoint;
            },
            requestAccess: function (credentials) {
                const xhr = new XMLHttpRequest();
                xhr.addEventListener("load", function () {
                    if (xhr.status === 200) {
                        const data = JSON.parse(xhr.response);
                        credentials.success(data.Token);
                    } else {
                        credentials.error(xhr);
                    }
                });
                xhr.addEventListener("error", credentials.error);
                xhr.open("GET", instantToken.setEndpoint(credentials));
                xhr.send();
            }
        });

        const instagram = app.createContext(app);

        instagram.addProperties({
            pictures: instagram.toArray(document.querySelectorAll("[data-instagram-img-src")),
            runBackupTask: function () {
                instagram.pictures.forEach(function (picture) {
                    instagram.lazy(picture, {
                        src: "data-instagram-img-src"
                    });
                });
            },
            setEndpoint: function (accessToken) {
                if (this.isString(accessToken)) {
                    let endpoint =
                        "https://graph.instagram.com/me/media?fields=caption,id,media_type,media_url,permalink,thumbnail_url,timestamp,username&access_token={accessToken}";

                    endpoint = endpoint.replace("{accessToken}", accessToken);
                    return endpoint;
                } else {
                    console.warn("An access token is required to make a call to the Instagram Basic Display API. The parameter given was instead: " + accessToken);
                }
            },
            processRecords: function (records) {
                const imageRecords = records.filter(function (record) {
                    return record.media_type === "IMAGE";
                });

                instagram.pictures.forEach(function (picture, i) {
                    const record = imageRecords[i];
                    const mediaUrl = record.media_url;
                    picture.dataset.instagramImgSrc = mediaUrl;
                    const linkUrl = record.permalink;

                    picture.href = linkUrl;

                    instagram.lazy(picture, {
                        src: "data-instagram-img-src"
                    });
                });
            },
            requestMedia: function (accessToken) {
                if (instagram.isString(accessToken)) {
                    const xhr = new XMLHttpRequest();

                    xhr.addEventListener("load", function () {
                        if (xhr.status === 200) {
                            const data = JSON.parse(xhr.response);
                            instagram.processRecords(data.data);
                        } else {
                            instagram.runBackupTask();
                        }
                    });
                    xhr.addEventListener("error", instagram.runBackupTask);
                    xhr.open("GET", instagram.setEndpoint(accessToken));
                    xhr.send();
                }
            },
            processTask: function (service) {
                if (this.isFunction(service)) {
                    service(this);
                }
            }
        });

        instagram.processTask(function (api) {
            return instantToken.requestAccess({
                userId: "aa697096-1f32-4328-84fc-fd9f3b2d38a6",
                instagramId: "17841400919281932",
                userSecret: "2i2j9028kifyvxec4mdezf",
                success: api.requestMedia,
                error: api.runBackupTask
            });
        });
    }
})(window);
