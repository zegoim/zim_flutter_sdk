#ifndef __ZegoServerAssistantImpl__
#define __ZegoServerAssistantImpl__

#include <stdint.h>
#include <map>
#include <string>

struct TokenParams {
    uint32_t           appID;
    std::string        userID;
    int64_t            nonce;
    int64_t            createTime;
    int64_t            expireTime;
    std::string        payload;
    TokenParams(uint32_t appID1, const std::string& userID1, int64_t createTime1, int64_t expireTime1, int64_t nonce1)
      : appID(appID1), userID(userID1), createTime(createTime1), expireTime(expireTime1), nonce(nonce1), payload("")
    {}
};

namespace ZEGO
{
namespace SERVER_ASSISTANT
{
    class ZegoServerAssistantImpl
    {
    public:
        std::string GenerateToken(uint32_t appID, const std::string& userID, const std::string& secret, int64_t effectiveTimeInSeconds);

    private:
        int64_t MakeNonce();

        // 随机生成 16 字节字符串，用作 AES 加密，放在密文前一起做 Base64 编码
        // 编码最终生成 token
        std::string MakeRandomIv();

        // 把 token 信息转成 json
        std::string TokenToJson(const TokenParams& params);

        // 进行 AES 加密
        std::string AesEncrypt(const std::string& origData, const std::string& key, const std::string& iv);
    };
}  // namespace SERVER_ASSISTANT

}  // namespace ZEGO

#endif  // __ZegoServerAssistantImpl__
