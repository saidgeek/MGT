$('document').ready(function () {
  console.log('entro a funcines');
  var alto = $(window).height();

  var total_width = $('#wrap').width();
  console.log($('#wrap').width());
  var sidebar = $('#side').width();
  var medida = total_width - sidebar;

  var maxAncho = medida / 100 * 65;
  var minAncho = medida / 100 * 35;

  console.log(total_width);
  console.log(sidebar);
  console.log(medida);

  console.log($('#left').height());


  $('#main').width(medida);
  $('#main .wrap, #side').height(alto);

  $( "#left .relativo" ).resizable({
      maxWidth: maxAncho,
      minWidth: minAncho,
      containment: '#main',
      handles: "ew",
      grid: [ 0, 0 ]
  }).bind( "resize", resize_other, resize_right);

  $(window).on('resize', resize_other);

  function resize_other(event, ui) {

      var width = $("#left .relativo").width();

      total_width = $('#main').width();

      if(width > total_width) {
          width = total_width;
          $('#left').css('width', width);
      }

      $('#right').css('width', total_width - width);

      $('.ui-resizable-handle').css('left', width);
  }


  function resizeStop(event, ui){
      convert_to_percentage($(this));
  }

  function setContainerResizer(event, ui) {
      console.log($(this)[0]);
      $($(this)[0]).children('.ui-resizable-handle').mouseover(setContainerSize);
  }

  function convert_to_percentage(el){
      var parent = el.parent();
      el.css({ width: el.width()/parent.width()*100+"%",});
  }

  $( ".overflow" ).mCustomScrollbar({
      scrollButtons:{
          enable:false
      }
  });



  function resize_right(event, ui) {

      var right = $("#right").width();

      console.log(right);

      if(right < 600) {
          $('.menu-middle p, .tools ul li p').css('display', 'none');
          $('.edit-user ul li a').css({'textIndent':'-9999px', 'overflow':'hidden'});
      }else{
          $('.menu-middle p, .tools ul li p').css('display', 'inline');
          $('.edit-user ul li a').css({'textIndent':0, 'overflow':'auto'});
      }

  }

  $('#right').on('resize', resize_right);

  $('span.opt-check').click(function(){
      $(this).parent().find('.hide').trigger('click');
      $(this).toggleClass('active');
  });

  $('.note.round').click(function(){
      $('.note.round').removeClass('active');
      $(this).addClass('active');
      $('.note.round.active span').css({'display':'block'});

      if($('.overflow.admin').find('.note.round').attr('title') == $(this).attr('id')){

          console.log('iguales!');

      }
  });

  $('.hideshow a').bind('click', function(){
      $(this).find('span.down').toggleClass('up');
      $('.esconder').slideToggle(0);
      $('#nueva-solicitud').toggleClass('auto');
  });

  $('.close a').click(function(){
      $('#nueva-solicitud').css({'opacity':0, 'zIndex':-1});
  });

  $('a.boton1').click(function(){
      $('#nueva-solicitud').css({'opacity':1, 'zIndex':999});
  });

  $('a.sub-not').click(function(){
      $('#submenu').slideToggle(200);
  });

  $('.menu-middle li a').click(function(){
      $('.menu-middle li a').removeClass('active');
      $(this).addClass('active');
  });
  $('.archivos .dato a').click(function(){
      $(this).parent().parent().find('.docu').slideToggle(400);
      $(this).find('span').toggleClass('abierto');
  });
  $('.archivos:first .docu').css({'display':'block'});
  $('.archivos:first .dato a span').addClass('abierto');

  $('.involucrados .dato a').click(function(){
      $(this).parent().parent().find('.docu').slideToggle(400);
      $(this).find('span').toggleClass('abierto');
  });
  $('.involucrados:first .docu').css({'display':'block'});
  $('.involucrados:first .dato a span').addClass('abierto');

  $('.subtarea .dato span.opt-check').click(function(){
      $(this).parent().parent().parent().addClass('done');
  });
  $('.subtarea .dato a').click(function(){
      $('.subtarea .dato span.opt-check').removeClass('active');
      $(this).parent().removeClass('done');
  });
  $('.alerta a.cerrar').click(function(){
      $('.alerta').slideToggle(400);
  });
  $('#perfil-editar ul li .editar a').click(function(){
      $(this).parent().parent().parent().find('.esconder').slideToggle(400);
  });
});
