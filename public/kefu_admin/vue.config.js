module.exports = {
    publicPath: process.env.NODE_ENV === 'production' ? './' : '/',
    outputDir: '../admin/',
    devServer: {
        proxy: 'http://localhost:8080',
    }
}
