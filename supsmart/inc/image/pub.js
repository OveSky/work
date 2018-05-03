function getComment(url){
	$.ajax({
		type:"GET",
		url:url,
		cache: false,
		dataType:"html",
		success:function(date){
		    $("#comment_list").html(date);
		}
	});
}
function getLogin(url){
	$.ajax({
		type:"GET",
		url:url,
		cache: false,
		dataType:"html",
		success:function(date){
		    $("#m_login").html(date);
		}
	});
}
function getVote(url){
	$.ajax({
		type:"GET",
		url:url,
		cache: false,
		dataType:"html",
		success:function(date){
		    $("#vote_ctr").html(date);
		}
	});
}
function checkPower(url){
	$.ajax({
		type:"GET",
		url:url,
		cache: false,
		dataType:"html",
		success:function(date){
			if(date.indexOf("read_ctr")<0){
		        $("#read_ctr").html(date);
			}
		}
	});
}
function addHits(url){
	$.ajax({
		type:"GET",
		url:url,
		cache: false,
		dataType:"html",
		success:function(date){
		}
	});
}