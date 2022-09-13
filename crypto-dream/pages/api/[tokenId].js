export default function handler(req, res) {
  const tokenId = req.query.tokenId;
  const image_url =
    "https://raw.githubusercontent.com/LearnWeb3DAO/NFT-Collection/main/my-app/public/cryptodevs/";
  res.status(200).json({
    name: "Crypto Dreamer #" + tokenId,
    description: "Crypto Dreamer is a collection of Crypto Dreamers",
    image: image_url + tokenId + ".svg",
  });
}
