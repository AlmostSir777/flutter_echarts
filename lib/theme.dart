const darkThemeScript = r'''
(function(root, factory) {
    if (typeof define === 'function' && define.amd) {
        // AMD. Register as an anonymous module.
        define(['exports', 'echarts'], factory);
    } else if (
        typeof exports === 'object' &&
        typeof exports.nodeName !== 'string'
    ) {
        // CommonJS
        factory(exports, require('echarts/lib/echarts'));
    } else {
        // Browser globals
        factory({}, root.echarts);
    }
})(this, function(exports, echarts) {
    var log = function(msg) {
        if (typeof console !== 'undefined') {
            console && console.error && console.error(msg);
        }
    };
    if (!echarts) {
        log('ECharts is not Loaded');
        return;
    }
    var contrastColor = '#8b8b8b';
    // var backgroundColor = '#100C2A';
    var axisCommon = function () {
        return {
         axisLabel:{
      textStyle:{
        color:'#8b8b8b',
      }
      },
            axisLine: {
                lineStyle: {
                    width:1,
                    color: '#3c3c42'
                }
            },
            splitLine: {
                lineStyle: { 
                width:0.5,
                    color: '#3c3c42'
                }
            },
            splitArea: {
                areaStyle: {
                    color: ['rgba(255,255,255,0.02)', 'rgba(255,255,255,0.05)']
                }
            },
            minorSplitLine: {
                lineStyle: {
                    color: '#3c3c42'
                }
            }
        };
    };

    var colorPalette = [
      "#f25353",
      "#5471c5",
      "#3da071",
      "#9a60b3",
      "#998df1",
      "#1890ff",
      "#2fc25b",
      "#facc14",
      "#f04864",
      "#8543e0",
      "#90ed7d"
    ];
    var theme = {
        darkMode: true,
        color: colorPalette,
        textStyle: {
                fontWeight: 'normal',
                color: '#8b8b8b'
            },
        axisPointer: {
            lineStyle: {
                color: '#3c3c42'
            },
            crossStyle: {
                color: '#3c3c42'
            },
            label: {
                color: '#8b8b8b'
            }
        },
        legend: {
              textStyle: {
      color: '#dbdbdb',
      fontSize:13
    },
    pageTextStyle: {
      color: '#dbdbdb',
      fontSize:11
    }
        },
        textStyle: {
            color: contrastColor
        },
        title: {
            textStyle: {
                color: '#EEF1FA'
            },
            subtextStyle: {
                color: '#B9B8CE'
            }
        },
         tooltip: {
            backgroundColor: 'rgba(28,28,32,0.8)', 
            borderColor: "#00000000",
            textStyle: {
                color: '#fff'
           },
            axisPointer: {
                type: 'line',
                lineStyle: {
                    color: '#dbdbdb'
                }
            }
        },
        dataZoom: {
            borderColor: '#71708A',
            textStyle: {
                color: contrastColor
            },
            brushStyle: {
                color: 'rgba(135,163,206,0.3)'
            },
            handleStyle: {
                color: '#353450',
                borderColor: '#C5CBE3'
            },
            moveHandleStyle: {
                color: '#B0B6C3',
                opacity: 0.3
            },
            fillerColor: 'rgba(135,163,206,0.2)',
            emphasis: {
                handleStyle: {
                    borderColor: '#91B7F2',
                    color: '#4D587D'
                },
                moveHandleStyle: {
                    color: '#636D9A',
                    opacity: 0.7
                }
            },
            dataBackground: {
                lineStyle: {
                    color: '#71708A',
                    width: 1
                },
                areaStyle: {
                    color: '#71708A'
                }
            },
            selectedDataBackground: {
                lineStyle: {
                    color: '#87A3CE'
                },
                areaStyle: {
                    color: '#87A3CE'
                }
            }
        },
        visualMap: {
            textStyle: {
                color: contrastColor
            }
        },
        timeline: {
            lineStyle: {
                color: contrastColor
            },
            label: {
                color: contrastColor
            },
            controlStyle: {
                color: contrastColor,
                borderColor: contrastColor
            }
        },
        calendar: {
            dayLabel: {
                color: contrastColor
            },
            monthLabel: {
                color: contrastColor
            },
            yearLabel: {
                color: contrastColor
            }
        },
        timeAxis: axisCommon(),
        logAxis: axisCommon(),
        valueAxis: axisCommon(),
        categoryAxis: axisCommon(),

        line: {
            symbol: 'circle'
        },
        graph: {
            color: colorPalette
        },
        gauge: {
            title: {
                color: contrastColor
            }
        },
        candlestick: {
            itemStyle: {
                color: '#FD1050',
                color0: '#0CF49B',
                borderColor: '#FD1050',
                borderColor0: '#0CF49B'
            }
        },
         yAxis: {
    nameTextStyle: {              // Y 轴名称样式
      color: '#8b8b8b',             // 轴名称颜色‌:ml-citation{ref="3" data="citationList"}
    },
     axisLine: {
                lineStyle: {
                width:1,
                    color: '#3c3c42'
                }
            },
    splitLine: {                 // Y 轴分割线
      lineStyle: {
        color: '#3c3c42',           // 分割线颜色‌:ml-citation{ref="3" data="citationList"}
        width: 0.5
      }
    }
  }
    };

    theme.categoryAxis.splitLine.show = false;
    echarts.registerTheme('dark', theme);
});
''';

const lightThemeScript = r'''
(function(root, factory) {
    if (typeof define === 'function' && define.amd) {
        // AMD. Register as an anonymous module.
        define(['exports', 'echarts'], factory);
    } else if (
        typeof exports === 'object' &&
        typeof exports.nodeName !== 'string'
    ) {
        // CommonJS
        factory(exports, require('echarts/lib/echarts'));
    } else {
        // Browser globals
        factory({}, root.echarts);
    }
})(this, function(exports, echarts) {
    var log = function(msg) {
        if (typeof console !== 'undefined') {
            console && console.error && console.error(msg);
        }
    };
    if (!echarts) {
        log('ECharts is not Loaded');
        return;
    }

    var colorPalette = [
      "#f25353",
      "#5471c5",
      "#3da071",
      "#9a60b3",
      "#998df1",
      "#1890ff",
      "#2fc25b",
      "#facc14",
      "#f04864",
      "#8543e0",
      "#90ed7d"
    ];
   var textColor = '#565960';
    var theme = {
        color: colorPalette,
        textStyle: {
                fontWeight: 'normal',
                color: textColor
            },
        title: {
            textStyle: {
                fontWeight: 'normal',
                color: textColor
            },
            subtextStyle:{
              fontWeight: 'normal',
                color: textColor
                }
        },

        visualMap: {
            itemWidth: 15,
            color: ['#5ab1ef', '#e0ffff']
        },
        legend: {
          textStyle: {
      color: textColor,
      fontSize:13
    },
    pageTextStyle: {
      color: textColor,
      fontSize:11
    }},
        tooltip: {
            borderWidth: 0,
            backgroundColor: '#00000080', 
            borderColor: "#00000000",
             axisPointer: {
             type: 'line',
                lineStyle: {
                    color: '#e3e3e3'
                }
            },
            textStyle: {
                color: '#FFF'
            }
        },

        dataZoom: {
            dataBackgroundColor: '#efefff',
            fillerColor: 'rgba(182,162,222,0.2)',
            handleColor: textColor
        },

        grid: {
            borderColor: '#eee'
        },

        categoryAxis: {
            axisLine: {
                lineStyle: {
                    width:1,
                    color: '#e3e3e3'
                }
            },
            splitLine: {
                lineStyle: {
                    width: 0.5,
                    color: ['#e3e3e3']
                }
            },
            
            axisLabel:{
      textStyle:{
        color:textColor,
        fontSize: 11
      }
    }
        },

        valueAxis: {
            axisLine: {
					      lineStyle:{
                 width:1, 
						   color:"#e3e3e3"
					}
            },
            splitLine: {
                lineStyle: {
                    width:0.5,
                    color: "#e3e3e3"
                }
            },
            axisLabel:{
      textStyle:{
        color:textColor,
        fontSize: 11
      }
    }
        },
         yAxis: {
    nameTextStyle: {  
      color: textColor, 
      fontSize: 11     
    }
  },
  
         yAxis: {
    nameTextStyle: {              // Y 轴名称样式
      color: textColor,             // 轴名称颜色‌:ml-citation{ref="3" data="citationList"}
    },
    axisLine: {
					      lineStyle:{
                 width:1, 
						   color:"#e3e3e3"
					}
            },
    splitLine: {                 // Y 轴分割线
      lineStyle: {
        color: '#e3e3e3',           // 分割线颜色‌:ml-citation{ref="3" data="citationList"}
        width: 0.5
      }
    }
  }
    };

    echarts.registerTheme('light', theme);
});
''';
