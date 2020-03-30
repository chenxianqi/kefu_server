module.exports = {
    publicPath: process.env.NODE_ENV === 'production' ? './' : '/',
    outputDir: '../../public/client/',
    devServer: {
        proxy: 'http://im.cmp520.com',
    }
}