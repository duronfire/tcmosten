const path = require('path')
const StyleLintPlugin = require('stylelint-webpack-plugin')
const STYLELINTENABLE = true
module.exports = {
    mode:'production',
    entry:'./src/index.js', //入口文件
    output:{ //通过webpack打包输出的最终目录及文件
        path:path.resolve(__dirname,'build'),
        filename:'bundle.js'
    },
    module:{ //对各种资源进行loader的配置处理
        rules:[
            //处理js/jsx
            {
                test:/\.jsx?/i,
                use:{
                    loader:'babel-loader',
                    options:{
                        presets: ["@babel/preset-react"]
                    }
                }
            },
            //处理css
            {
                test:/\.css$/i,
                use:['style-loader','css-loader',{
                    loader:'postcss-loader',
                    options:{
                        plugins:require('autoprefixer')
                    }
                }]
            },
            //处理图片资源
            {
                test:/\.(png|jpg|gif)$/i,
                use:{
                    loader:'url-loader',
                    options:{
                        outputPath:'imgs/',
                        limit:10*1024
                    }
                }
            },
            //处理字体文件
            {
                test:/\.(eot|svg|ttf|woof|woof2)$/i,
                use:{
                    loader:'url-loader',
                    options:{
                        outputPath:'fonts/',
                        limit:10*1024
                    }
                }
            },
            //less
            {
                test:/\.less$/i,
                use:['style-loader','css-loader','less-loader']
            },

        ]
    },


    devtool:'source-map',
    plugins:[



    ]

}

