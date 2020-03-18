module.exports = {
    publicPath: process.env.NODE_ENV === 'production' ? './' : '/',
    outputDir: '../client/',
    devServer: {
        proxy: 'http://localhost:8080',
    }
}