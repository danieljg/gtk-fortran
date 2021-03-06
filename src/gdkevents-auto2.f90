! Automatically generated by extract_events.pl on Fri May 20 23:02:28 2011 Z
! Please do not modify (unless you really know what you're doing).
! This file is part of the gtk-fortran GTK+ Fortran Interface library.
! GNU General Public License version 3

module gdk_events
  use iso_c_binding

  implicit none

  type, bind(c) :: GdkPoint
    integer(kind=c_int) :: x  ! gint
    integer(kind=c_int) :: y  ! gint
  end type GdkPoint

  type, bind(c) :: GdkRectangle
    integer(kind=c_int) :: x  ! gint
    integer(kind=c_int) :: y  ! gint
    integer(kind=c_int) :: width  ! gint
    integer(kind=c_int) :: height  ! gint
  end type GdkRectangle

  type, bind(c) :: GdkSegment
    integer(kind=c_int) :: x1  ! gint
    integer(kind=c_int) :: y1  ! gint
    integer(kind=c_int) :: x2  ! gint
    integer(kind=c_int) :: y2  ! gint
  end type GdkSegment

  type, bind(c) :: GdkSpan
    integer(kind=c_int) :: x  ! gint
    integer(kind=c_int) :: y  ! gint
    integer(kind=c_int) :: width  ! gint
  end type GdkSpan

  type, bind(c) :: GdkEventAny
    integer(kind=c_int) :: type    ! enum GdkEventType
    type(c_ptr) :: window   ! -> GdkWindow
    integer(kind=c_int8_t) :: send_event  ! gint8
  end type GdkEventAny

  type, bind(c) :: GdkEventExpose
    integer(kind=c_int) :: type    ! enum GdkEventType
    type(c_ptr) :: window   ! -> GdkWindow
    integer(kind=c_int8_t) :: send_event  ! gint8
    type(GdkRectangle) :: area  ! GdkRectangle
    type(c_ptr) :: region   ! -> GdkRegion
    integer(kind=c_int) :: count  ! gint
  end type GdkEventExpose

  type, bind(c) :: GdkEventNoExpose
    integer(kind=c_int) :: type    ! enum GdkEventType
    type(c_ptr) :: window   ! -> GdkWindow
    integer(kind=c_int8_t) :: send_event  ! gint8
  end type GdkEventNoExpose

  type, bind(c) :: GdkEventVisibility
    integer(kind=c_int) :: type    ! enum GdkEventType
    type(c_ptr) :: window   ! -> GdkWindow
    integer(kind=c_int8_t) :: send_event  ! gint8
    integer(kind=c_int) :: state    ! enum GdkVisibilityState
  end type GdkEventVisibility

  type, bind(c) :: GdkEventMotion
    integer(kind=c_int) :: type    ! enum GdkEventType
    type(c_ptr) :: window   ! -> GdkWindow
    integer(kind=c_int8_t) :: send_event  ! gint8
    integer(kind=c_int32_t) :: time  ! guint32
    real(kind=c_double) :: x  ! gdouble
    real(kind=c_double) :: y  ! gdouble
    type(c_ptr) :: axes   ! -> gdouble
    integer(kind=c_int) :: state  ! guint
    integer(kind=c_int16_t) :: is_hint  ! gint16
    type(c_ptr) :: device   ! -> GdkDevice
    real(kind=c_double) :: x_root, y_root  ! gdouble
  end type GdkEventMotion

  type, bind(c) :: GdkEventButton
    integer(kind=c_int) :: type    ! enum GdkEventType
    type(c_ptr) :: window   ! -> GdkWindow
    integer(kind=c_int8_t) :: send_event  ! gint8
    integer(kind=c_int32_t) :: time  ! guint32
    real(kind=c_double) :: x  ! gdouble
    real(kind=c_double) :: y  ! gdouble
    type(c_ptr) :: axes   ! -> gdouble
    integer(kind=c_int) :: state  ! guint
    integer(kind=c_int) :: button  ! guint
    type(c_ptr) :: device   ! -> GdkDevice
    real(kind=c_double) :: x_root, y_root  ! gdouble
  end type GdkEventButton

  type, bind(c) :: GdkEventScroll
    integer(kind=c_int) :: type    ! enum GdkEventType
    type(c_ptr) :: window   ! -> GdkWindow
    integer(kind=c_int8_t) :: send_event  ! gint8
    integer(kind=c_int32_t) :: time  ! guint32
    real(kind=c_double) :: x  ! gdouble
    real(kind=c_double) :: y  ! gdouble
    integer(kind=c_int) :: state  ! guint
    integer(kind=c_int) :: direction    ! enum GdkScrollDirection
    type(c_ptr) :: device   ! -> GdkDevice
    real(kind=c_double) :: x_root, y_root  ! gdouble
  end type GdkEventScroll

  type, bind(c) :: GdkEventKey
    integer(kind=c_int) :: type    ! enum GdkEventType
    type(c_ptr) :: window   ! -> GdkWindow
    integer(kind=c_int8_t) :: send_event  ! gint8
    integer(kind=c_int32_t) :: time  ! guint32
    integer(kind=c_int) :: state  ! guint
    integer(kind=c_int) :: keyval  ! guint
    integer(kind=c_int) :: length  ! gint
    type(c_ptr) :: string   ! -> gchar
    integer(kind=c_int16_t) :: hardware_keycode  ! guint16
    integer(kind=c_int8_t) :: group  ! guint8
    integer(kind=c_int) :: is_modifier = 1  ! guint
  end type GdkEventKey

  type, bind(c) :: GdkEventCrossing
    integer(kind=c_int) :: type    ! enum GdkEventType
    type(c_ptr) :: window   ! -> GdkWindow
    integer(kind=c_int8_t) :: send_event  ! gint8
    type(c_ptr) :: subwindow   ! -> GdkWindow
    integer(kind=c_int32_t) :: time  ! guint32
    real(kind=c_double) :: x  ! gdouble
    real(kind=c_double) :: y  ! gdouble
    real(kind=c_double) :: x_root  ! gdouble
    real(kind=c_double) :: y_root  ! gdouble
    integer(kind=c_int) :: mode    ! enum GdkCrossingMode
    integer(kind=c_int) :: detail    ! enum GdkNotifyType
    integer(kind=c_int) :: focus  ! gboolean
    integer(kind=c_int) :: state  ! guint
  end type GdkEventCrossing

  type, bind(c) :: GdkEventFocus
    integer(kind=c_int) :: type    ! enum GdkEventType
    type(c_ptr) :: window   ! -> GdkWindow
    integer(kind=c_int8_t) :: send_event  ! gint8
    integer(kind=c_int16_t) :: in  ! gint16
  end type GdkEventFocus

  type, bind(c) :: GdkEventConfigure
    integer(kind=c_int) :: type    ! enum GdkEventType
    type(c_ptr) :: window   ! -> GdkWindow
    integer(kind=c_int8_t) :: send_event  ! gint8
    integer(kind=c_int) :: x, y  ! gint
    integer(kind=c_int) :: width  ! gint
    integer(kind=c_int) :: height  ! gint
  end type GdkEventConfigure

  type, bind(c) :: GdkEventProperty
    integer(kind=c_int) :: type    ! enum GdkEventType
    type(c_ptr) :: window   ! -> GdkWindow
    integer(kind=c_int8_t) :: send_event  ! gint8
    type(c_ptr) :: atom  ! GdkAtom
    integer(kind=c_int32_t) :: time  ! guint32
    integer(kind=c_int) :: state  ! guint
  end type GdkEventProperty

  type, bind(c) :: GdkEventSelection
    integer(kind=c_int) :: type    ! enum GdkEventType
    type(c_ptr) :: window   ! -> GdkWindow
    integer(kind=c_int8_t) :: send_event  ! gint8
    type(c_ptr) :: selection  ! GdkAtom
    type(c_ptr) :: target  ! GdkAtom
    type(c_ptr) :: property  ! GdkAtom
    integer(kind=c_int32_t) :: time  ! guint32
    type(c_ptr) :: requestor  ! GdkNativeWindow
  end type GdkEventSelection

  type, bind(c) :: GdkEventOwnerChange
    integer(kind=c_int) :: type    ! enum GdkEventType
    type(c_ptr) :: window   ! -> GdkWindow
    integer(kind=c_int8_t) :: send_event  ! gint8
    type(c_ptr) :: owner  ! GdkNativeWindow
    integer(kind=c_int) :: reason    ! enum GdkOwnerChange
    type(c_ptr) :: selection  ! GdkAtom
    integer(kind=c_int32_t) :: time  ! guint32
    integer(kind=c_int32_t) :: selection_time  ! guint32
  end type GdkEventOwnerChange

  type, bind(c) :: GdkEventProximity
    integer(kind=c_int) :: type    ! enum GdkEventType
    type(c_ptr) :: window   ! -> GdkWindow
    integer(kind=c_int8_t) :: send_event  ! gint8
    integer(kind=c_int32_t) :: time  ! guint32
    type(c_ptr) :: device   ! -> GdkDevice
  end type GdkEventProximity

!!$union{} is not Fortran interoperable
!!$  type, bind(c) :: GdkEventClient
!!$    integer(kind=c_int) :: type    ! enum GdkEventType
!!$    type(c_ptr) :: window   ! -> GdkWindow
!!$    integer(kind=c_int8_t) :: send_event  ! gint8
!!$    type(c_ptr) :: message_type  ! GdkAtom
!!$    integer(kind=c_short) :: data_format  ! gushort
!!$!  union { ******
!!$    character(kind=c_char) :: b[20]  ! char
!!$    integer(kind=c_short) :: s[10]  ! short
!!$    integer(kind=c_long) :: l[5]  ! long
!!$!  } data; ******
!!$  end type GdkEventClient

  type, bind(c) :: GdkEventSetting
    integer(kind=c_int) :: type    ! enum GdkEventType
    type(c_ptr) :: window   ! -> GdkWindow
    integer(kind=c_int8_t) :: send_event  ! gint8
    integer(kind=c_int) :: action    ! enum GdkSettingAction
    type(c_ptr) :: name   ! -> char
  end type GdkEventSetting

  type, bind(c) :: GdkEventWindowState
    integer(kind=c_int) :: type    ! enum GdkEventType
    type(c_ptr) :: window   ! -> GdkWindow
    integer(kind=c_int8_t) :: send_event  ! gint8
    integer(kind=c_int) :: changed_mask    ! enum GdkWindowState
    integer(kind=c_int) :: new_window_state    ! enum GdkWindowState
  end type GdkEventWindowState

  type, bind(c) :: GdkEventGrabBroken
    integer(kind=c_int) :: type    ! enum GdkEventType
    type(c_ptr) :: window   ! -> GdkWindow
    integer(kind=c_int8_t) :: send_event  ! gint8
    integer(kind=c_int) :: keyboard  ! gboolean
    integer(kind=c_int) :: implicit  ! gboolean
    type(c_ptr) :: grab_window   ! -> GdkWindow
  end type GdkEventGrabBroken

  type, bind(c) :: GdkEventDND
    integer(kind=c_int) :: type    ! enum GdkEventType
    type(c_ptr) :: window   ! -> GdkWindow
    integer(kind=c_int8_t) :: send_event  ! gint8
    type(c_ptr) :: context   ! -> GdkDragContext
    integer(kind=c_int32_t) :: time  ! guint32
    integer(kind=c_short) :: x_root, y_root  ! gshort
  end type GdkEventDND

end module gdk_events
