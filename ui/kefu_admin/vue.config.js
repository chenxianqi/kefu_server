module.exports = {
    publicPath: process.env.NODE_ENV === 'production' ? './' : '/',
    outputDir: '../../public/admin/',
    devServer: {
        proxy: 'http://im.cmp520.com',
    }
}
