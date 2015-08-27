;(function ($) {
	var loadingconf = {
			'iscmask':0,//是否有蒙层
			'isbg':'rgba(82,54,105,0.4)',//紫色背景
	        'text':'',//加载文字提示
	        'istouch':true,
	        'callbacks' : function() {}// 加载成功以后
	}    
	var loadingthistimeout=null;
    $.fn.ourLoading = function(options) {
		loadingconf = $.extend(loadingconf, options);
        var _self = $(this);
        _self.find('.loading,.mask_c').remove();
        
        var loadingtest="";
        if(loadingconf.text!=''){
        	loadingtest='<td><span class="loading_test">'+loadingconf.text+'</span></td>';
        }
        if(loadingconf.iscmask==1){
        	_self.css('position','relative').append('<div class="mask_c">'+
									        			'<div class="loading">'+
												        	'<table class="loading_pic_w">'+
													        	'<tr>'+
														        	'<td>'+
														        		'<span class="loading_pic wkloading"></span>'+
														        	'</td>'+loadingtest+
													        	'</tr>'+
												        	'</table>'+
												        '</div>'+
												     '</div>');
        }
        else{
        	_self.css('position','relative').append('<div class="mask_cre"><div class="loading">'+
											        	'<table class="loading_pic_w" border="0" cellpadding="0" cellspacing="0">'+
												        	'<tr>'+
													        	'<td>'+
													        		'<span class="loading_pic wkloading"></span>'+
													        	'</td>'+loadingtest+
												        	'</tr>'+
											        	'</table>'+
											     	'</div></div>');

        }
        if(loadingconf.isbg!=''){
        	_self.find('.loading_pic_w').css('background',loadingconf.isbg);
        }
        
        //istouch设置为false，即不可滑动
        if(!loadingconf.istouch){
//        	$('.loading_pic_w')[0].addEventListener('touchmove',function(e){e.preventDefault()});
        	$('body')[0].addEventListener('touchmove',function(e){e.preventDefault()});
        }
        
        setTimeout(function(){
        	_self.find('.loading_pic').addClass('loadingrotate');
        	thistimeout=setTimeout(function(){
        		$('.loading,.mask_c,.mask_cre').remove();
        	},40000)
        },10);
    };
    $.extend($.fn, {
    	ourUnLoading:function() {
        	var _self = $(this);
        	clearTimeout(loadingthistimeout);
            _self.find('.loading,.mask_c,.mask_cre').remove();
        },
    });
})($);