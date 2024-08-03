module.exports = {
  configureWebpack: {
    module: {
      rules: [
        {
          test: /\.m?js$/,
          exclude: /node_modules\/(?!ethers)/,
          use: {
            loader: "babel-loader",
            options: {
              presets: ["@babel/preset-env"],
              plugins: ["@babel/plugin-transform-runtime"],
            },
          },
        },
      ],
    },
  },
};
