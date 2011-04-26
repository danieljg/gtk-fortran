! Copyright (C) 2011
! Free Software Foundation, Inc.

! This file is part of the gtk-fortran gtk+ Fortran Interface library.

! This is free software; you can redistribute it and/or modify
! it under the terms of the GNU General Public License as published by
! the Free Software Foundation; either version 3, or (at your option)
! any later version.

! This software is distributed in the hope that it will be useful,
! but WITHOUT ANY WARRANTY; without even the implied warranty of
! MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
! GNU General Public License for more details.

! Under Section 7 of GPL version 3, you are granted additional
! permissions described in the GCC Runtime Library Exception, version
! 3.1, as published by the Free Software Foundation.

! You should have received a copy of the GNU General Public License along with
! this program; see the files COPYING3 and COPYING.RUNTIME respectively.
! If not, see <http://www.gnu.org/licenses/>.
!
! Contributed by Vincent Magnin and Jerry DeLisle 
! Last modification: 04-26-2011

module global_widgets
  use iso_c_binding, only: c_ptr, c_char
  type(c_ptr) :: my_pixbuf, my_drawing_area, spinButton1, spinButton2, spinButton3
  type(c_ptr) :: textView, buffer, scrolled_window, statusBar
  character(c_char), dimension(:), pointer :: pixel
  integer :: nch, rowstride, width, height, pixwidth, pixheight
  logical :: computing = .false.
  character(LEN=80) :: string
end module global_widgets


module handlers
  use gtk, only: gtk_container_add, gtk_drawing_area_new, gtk_events_pending, gtk&
  &_main, gtk_main_iteration, gtk_main_iteration_do, gtk_widget_get_window, gtk_w&
  &idget_queue_draw, gtk_widget_show, gtk_window_new, gtk_window_set_default, gtk&
  &_window_set_default_size, gtk_window_set_title, TRUE, FALSE, NULL, CNULL, &
  &GDK_COLORSPACE_RGB, GTK_WINDOW_TOPLEVEL, gtk_init, g_signal_connect, &
  &gtk_table_new, gtk_table_attach_defaults, gtk_container_add, gtk_button_new_with_label,&
  &gtk_widget_show_all, gtk_vbox_new, gtk_box_pack_start, gtk_spin_button_new,&
  &gtk_adjustment_new, gtk_spin_button_get_value, gtk_label_new, &
  &gtk_expander_new_with_mnemonic, gtk_expander_set_expanded, gtk_main_quit, &
  &gtk_toggle_button_new_with_label, gtk_toggle_button_get_active, gtk_notebook_new,&
  &gtk_notebook_append_page, gtk_text_view_new, gtk_text_view_get_buffer, gtk_text_buffer_set_text,&
  &gtk_scrolled_window_new, C_NEW_LINE, gtk_text_buffer_insert_at_cursor, gtk_statusbar_new,&
  &gtk_statusbar_push, gtk_statusbar_get_context_id, gtk_handle_box_new,&
  &CAIRO_STATUS_SUCCESS, CAIRO_STATUS_NO_MEMORY, CAIRO_STATUS_SURFACE_TYPE_MISMATCH,&
  &CAIRO_STATUS_WRITE_ERROR, gtk_button_new_with_mnemonic, gtk_link_button_new_with_label,&
  &gtk_toggle_button_new_with_mnemonic, gtk_label_new_with_mnemonic, gtk_window_set_mnemonics_visible
  
  use cairo, only: cairo_create, cairo_destroy, cairo_paint, cairo_set_source, &
  &cairo_surface_write_to_png, cairo_get_target
  
  use gdk, only: gdk_cairo_create, gdk_cairo_set_source_pixbuf
  
  use gdk_pixbuf, only: gdk_pixbuf_get_n_channels, gdk_pixbuf_get_pixels, gdk_pix&
  &buf_get_rowstride, gdk_pixbuf_new

  use g, only: g_usleep
  
  use iso_c_binding, only: c_int, c_ptr, c_char

  implicit none
  integer(c_int) :: run_status = TRUE
  integer(c_int) :: boolresult
  logical :: boolevent
  
contains
  ! User defined event handlers go here
  function delete_event (widget, event, gdata) result(ret)  bind(c)
    use iso_c_binding, only: c_ptr, c_int
    integer(c_int)    :: ret
    type(c_ptr), value :: widget, event, gdata

    run_status = FALSE
    ret = FALSE
    call gtk_main_quit()
  end function delete_event


  subroutine pending_events ()
    do while(IAND(gtk_events_pending(), run_status) /= FALSE)
      boolresult = gtk_main_iteration_do(FALSE) ! False for non-blocking
    end do
  end subroutine pending_events


  function expose_event (widget, event, gdata) result(ret)  bind(c)
    use iso_c_binding, only: c_int, c_ptr
    use global_widgets
    implicit none
    integer(c_int)    :: ret
    type(c_ptr), value, intent(in) :: widget, event, gdata
    type(c_ptr) :: my_cairo_context
    integer(c_int) :: cstatus
    
    my_cairo_context = gdk_cairo_create (gtk_widget_get_window(widget))
    call gdk_cairo_set_source_pixbuf(my_cairo_context, my_pixbuf, 0d0, 0d0) 
    call cairo_paint(my_cairo_context)    
    call cairo_destroy(my_cairo_context)
    ret = FALSE
  end function expose_event


  ! GtkButton signal:
  function firstbutton (widget, gdata ) result(ret)  bind(c)
    use iso_c_binding, only: c_ptr
    use global_widgets
    implicit none
    
    integer(c_int)    :: ret, message_id
    type(c_ptr), value :: widget, gdata
    double complex :: c
    integer :: iterations
    
    c = gtk_spin_button_get_value (spinButton1) + &
        & (0d0, 1d0)*gtk_spin_button_get_value (spinButton2)
    iterations = INT(gtk_spin_button_get_value (spinButton3))

    write(string, '("c=",F8.6,"+i*",F8.6,"   ", I6, " iterations")') c, iterations
    call gtk_text_buffer_insert_at_cursor (buffer, string//C_NEW_LINE//CNULL, -1)

    message_id = gtk_statusbar_push (statusBar, gtk_statusbar_get_context_id(statusBar, &
              & "Julia"//CNULL), "Computing..."//CNULL)
    call Julia_set(-2d0, +2d0, -2d0, +2d0, c, iterations)
    message_id = gtk_statusbar_push (statusBar, gtk_statusbar_get_context_id(statusBar, &
              & "Julia"//CNULL), "Finished."//CNULL)

    ret = FALSE
  end function firstbutton

  ! GtkButton signal:
  function secondbutton (widget, gdata ) result(ret)  bind(c)
    use iso_c_binding, only: c_ptr
    use global_widgets
    implicit none
    
    integer(c_int)    :: ret
    type(c_ptr), value :: widget, gdata
    type(c_ptr) :: my_cairo_context
    integer(c_int) :: cstatus, message_id
    
    !my_cairo_context = gdk_cairo_create (gtk_widget_get_window(widget))
    my_cairo_context = gdk_cairo_create (gtk_widget_get_window(my_drawing_area))
    call gdk_cairo_set_source_pixbuf(my_cairo_context, my_pixbuf, 0d0, 0d0) 
    ! Save the picture if finished:
    if (.not. computing) then
      cstatus = cairo_surface_write_to_png(cairo_get_target(my_cairo_context), "julia.png"//CNULL)
      if (cstatus == CAIRO_STATUS_SUCCESS) then
        string = "Successfully saved: julia.png"//CNULL
      else if (cstatus == CAIRO_STATUS_NO_MEMORY) then
        string = "Failed: memory allocation"//CNULL
      else if (cstatus == CAIRO_STATUS_SURFACE_TYPE_MISMATCH) then
        string = "Failed: no pixel content"//CNULL
      else if (cstatus == CAIRO_STATUS_WRITE_ERROR) then
        string = "Failed: I/O error"//CNULL
      else
        string = "Failed"
      end if
      message_id = gtk_statusbar_push (statusBar, gtk_statusbar_get_context_id(statusBar, &
              & "Julia"//CNULL), TRIM(string))
    end if
    ! FIXME: how to save only the drawing_area
    call cairo_destroy(my_cairo_context)

    ret = FALSE
  end function secondbutton


  ! GtkToggleButton signal:
  function firstToggle (widget, gdata ) result(ret)  bind(c)
    use iso_c_binding, only: c_ptr, c_long
    use global_widgets
    implicit none
    
    integer(c_int)    :: ret
    type(c_ptr), value :: widget, gdata

    if (gtk_toggle_button_get_active(widget) == TRUE) then
      call gtk_text_buffer_insert_at_cursor (buffer, "In pause (don't try to quit the window)"//C_NEW_LINE//CNULL, -1)
      do while (gtk_toggle_button_get_active(widget) == TRUE)
        call pending_events
        call g_usleep(500000_c_long)   ! microseconds
        !call sleep(1)   ! Seconds. GNU Fortran extension. 
      end do
      !FIXME: if we try to quit during pause, the application crashes
    else
      call gtk_text_buffer_insert_at_cursor (buffer, "Not in pause"//C_NEW_LINE//CNULL, -1)
    end if
    
    ret = FALSE
  end function firstToggle
  
end module handlers


program julia
  use iso_c_binding, only: c_ptr, c_funloc, c_f_pointer
  use handlers
  use global_widgets
  implicit none
  
  type(c_ptr) :: my_window, table, button1, button2, button3, box1, label1, label2, label3
  type(c_ptr) :: toggle1, expander, notebook, notebookLabel1, notebookLabel2
  type(c_ptr) :: handle1, linkButton
  integer(c_int) :: message_id, firstTab, secondTab
  integer :: i
  
  call gtk_init ()
  
  ! Properties of the main window :
  width = 700
  height = 700
  my_window = gtk_window_new (GTK_WINDOW_TOPLEVEL)
  call gtk_window_set_default_size(my_window, width, height)
  call gtk_window_set_title(my_window, "Julia Set"//CNULL)
  call g_signal_connect (my_window, "delete-event"//CNULL, c_funloc(delete_event))

  button1 = gtk_button_new_with_mnemonic ("_Compute"//CNULL)
  call g_signal_connect (button1, "clicked"//CNULL, c_funloc(firstbutton))
  button2 = gtk_button_new_with_mnemonic ("_Save as PNG"//CNULL)
  call g_signal_connect (button2, "clicked"//CNULL, c_funloc(secondbutton))
  button3 = gtk_button_new_with_mnemonic ("_Exit"//CNULL)
  call g_signal_connect (button3, "clicked"//CNULL, c_funloc(delete_event))

  label1 = gtk_label_new("real(c)"//CNULL)
  spinButton1 = gtk_spin_button_new (gtk_adjustment_new(-0.835d0,-2d0,+2d0,0.05d0,0.5d0,0d0),0.05d0, 7)
  label2 = gtk_label_new("imag(c) "//CNULL)
  spinButton2 = gtk_spin_button_new (gtk_adjustment_new(-0.2321d0, -2d0,+2d0,0.05d0,0.5d0,0d0),0.05d0, 7)
  label3 = gtk_label_new("iterations"//CNULL)
  spinButton3 = gtk_spin_button_new (gtk_adjustment_new(1000d0,1d0,+100000d0,10d0,100d0,0d0),10d0, 0)

  toggle1 = gtk_toggle_button_new_with_mnemonic ("_Pause"//CNULL)
  call g_signal_connect (toggle1, "toggled"//CNULL, c_funloc(firstToggle))
  
  linkButton = gtk_link_button_new_with_label ("http://en.wikipedia.org/wiki/Julia_set"//CNULL,&
               & "More on Julia sets"//CNULL)
               
  ! A table container will contain buttons and labels:
  table = gtk_table_new (4, 4, TRUE)
  call gtk_table_attach_defaults(table, button1, 0, 1, 3, 4)
  call gtk_table_attach_defaults(table, button2, 1, 2, 3, 4)
  call gtk_table_attach_defaults(table, button3, 3, 4, 3, 4)
  call gtk_table_attach_defaults(table, label1, 0, 1, 0, 1)
  call gtk_table_attach_defaults(table, label2, 0, 1, 1, 2)
  call gtk_table_attach_defaults(table, label3, 0, 1, 2, 3)
  call gtk_table_attach_defaults(table, spinButton1, 1, 2, 0, 1)
  call gtk_table_attach_defaults(table, spinButton2, 1, 2, 1, 2)
  call gtk_table_attach_defaults(table, spinButton3, 1, 2, 2, 3)  
  call gtk_table_attach_defaults(table, linkButton, 3, 4, 0, 1)
  call gtk_table_attach_defaults(table, toggle1, 2, 3, 3, 4)

  ! The table is contained in an expander, which is contained in the vertical box:
  expander = gtk_expander_new_with_mnemonic ("_The parameters:"//CNULL)
  call gtk_container_add (expander, table)
  call gtk_expander_set_expanded(expander, TRUE)

  ! We create a vertical box container:
  box1 = gtk_vbox_new (FALSE, 10);
  call gtk_box_pack_start (box1, expander, FALSE, FALSE, 0)

  ! The drawing area is contained in the vertical box:
  my_drawing_area = gtk_drawing_area_new()
  call g_signal_connect (my_drawing_area, "expose-event"//CNULL, c_funloc(expose_event))
  ! In GTK+ 3.0 expose-event will be replaced by draw event:
  !call g_signal_connect (my_drawing_area, "draw"//CNULL, c_funloc(expose_event))
  notebook = gtk_notebook_new ()
  notebookLabel1 = gtk_label_new_with_mnemonic("_Graphics"//CNULL)
  firstTab = gtk_notebook_append_page (notebook, my_drawing_area, notebookLabel1)

  !handle1 = gtk_handle_box_new()
  
  textView = gtk_text_view_new ()
  buffer = gtk_text_view_get_buffer (textView)
  call gtk_text_buffer_set_text (buffer, "Julia Set"//C_NEW_LINE// &
      & "You can copy this text and even edit it !"//C_NEW_LINE//CNULL, -1)
  scrolled_window = gtk_scrolled_window_new (NULL, NULL)
  notebookLabel2 = gtk_label_new_with_mnemonic("_Messages"//CNULL)
  call gtk_container_add (scrolled_window, textView)
  !call gtk_container_add (handle1, scrolled_window)
  secondTab = gtk_notebook_append_page (notebook, scrolled_window, notebookLabel2)
  
  call gtk_box_pack_start (box1, notebook, TRUE, TRUE, 0)
 
  statusBar = gtk_statusbar_new ()
  message_id = gtk_statusbar_push (statusBar, gtk_statusbar_get_context_id(statusBar, &
              & "Julia"//CNULL), "Waiting..."//CNULL)
  call gtk_box_pack_start (box1, statusBar, FALSE, FALSE, 0)

  call gtk_container_add (my_window, box1)
  call gtk_window_set_mnemonics_visible (my_window, TRUE)
  call gtk_widget_show_all (my_window)
  
  ! We create a "pixbuffer" to store the pixels of the image:
  pixwidth  = 500
  pixheight = 500
  my_pixbuf = gdk_pixbuf_new(GDK_COLORSPACE_RGB, FALSE, 8, pixwidth, pixheight)    
  call c_f_pointer(gdk_pixbuf_get_pixels(my_pixbuf), pixel, (/0/))
  nch = gdk_pixbuf_get_n_channels(my_pixbuf)
  rowstride = gdk_pixbuf_get_rowstride(my_pixbuf)
  ! We use char() because we need unsigned integers.
  ! This pixbuffer has no Alpha channel (15% faster), only RGB.
  pixel = char(0)

  ! Main loop:
  call gtk_main ()
  print *, "All done"
end program julia 


!*********************************************
! Julia Set
! http://en.wikipedia.org/wiki/Julia_set
!*********************************************
subroutine Julia_set(xmin, xmax, ymin, ymax, c, itermax)
  use iso_c_binding
  use handlers
  use global_widgets
  implicit none

  integer    :: i, j, k, p, itermax
  double precision :: x, y, xmin, xmax, ymin, ymax ! coordinates in the complex plane
  double complex :: c, z   
  double precision :: scx, scy       ! scales
  integer(1) :: red, green, blue     ! rgb color
  double precision :: system_time, t0, t1
  
  computing = .true.
  t0=system_time()

  scx = ((xmax - xmin) / pixwidth)   ! x scale
  scy = ((ymax - ymin) / pixheight)  ! y scale
  
  do i=0, pixwidth-1
    ! We provoke an expose_event only once in a while to improve performances:
    if (mod(i,10)==0) then
      call gtk_widget_queue_draw(my_drawing_area)
    end if
    
    x = xmin + scx * i
    do j=0, pixheight-1
      y = ymin + scy * j
      z = x + y*(0d0,1d0)   ! Starting point
      k = 1
      do while ((k <= itermax) .and. ((real(z)**2+aimag(z)**2)<4d0)) 
        z = z*z + c
        k = k + 1
      end do
      
      if (k>itermax) then
        ! Black pixel:
        red   = 0
        green = 0
        blue  = 0
      else
        ! User defined palette:
        red   = min(255, k*2)
        green = min(255, k*5)
        blue  = min(255, k*10)
      end if
      
      ! We write in the pixbuffer:
      p = i * nch + j * rowstride + 1
      pixel(p)   = char(red)
      pixel(p+1) = char(green)
      pixel(p+2) = char(blue)

      ! This subroutine processes gtk events as needed during the computation.
      call pending_events()
      if (run_status == FALSE) return ! Exit if we had a delete event.
    end do
  end do
  ! Final update of the display:
  call gtk_widget_queue_draw(my_drawing_area)
  computing = .false.

  t1=system_time()
  write(string, '("System time = ",F8.3, " s")') t1-t0
  call gtk_text_buffer_insert_at_cursor (buffer, string//C_NEW_LINE//CNULL, -1)
  
end subroutine Julia_set

!***********************************************************
!  system time since 00:00
!***********************************************************
real(8) function system_time()   
  implicit none
  integer, dimension(8) :: dt
  
  call date_and_time(values=dt)
  system_time=dt(5)*3600d0+dt(6)*60d0+dt(7)+dt(8)*0.001d0
end function system_time
