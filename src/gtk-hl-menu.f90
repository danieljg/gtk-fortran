! Copyright (C) 2011
! Free Software Foundation, Inc.

! This file is part of the gtk-fortran GTK+ Fortran Interface library.

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
! Contributed by James Tappin
! Last modification: 12-1-2011

! --------------------------------------------------------
! gtk-hl-menu.f90
! Generated: Sun Aug 19 22:15:06 2012 GMT
! Please do not edit this file directly,
! Edit gtk-hl-menu-tmpl.f90, and use ./mk_gtk_hl.pl to regenerate.
! Generated for GTK+ version: 3.4.0.
! Generated for GLIB version: 2.32.0.
! --------------------------------------------------------


module gtk_hl_menu
  !*
  ! Pulldown Menu
  ! Implements the GtkMenuBar menu system.
  !/

  use gtk_sup
  use gtk_hl_misc

  use iso_c_binding
  use iso_fortran_env, only: error_unit

  ! autogenerated use's
  use gtk, only: gtk_check_menu_item_new,&
       & gtk_check_menu_item_new_with_label,&
       & gtk_check_menu_item_set_active, gtk_menu_bar_new,&
       & gtk_menu_bar_set_pack_direction, gtk_menu_item_new,&
       & gtk_menu_item_new_with_label, gtk_menu_item_set_submenu,&
       & gtk_menu_new, gtk_menu_shell_append, gtk_menu_shell_insert,&
       & gtk_radio_menu_item_get_group, gtk_radio_menu_item_new,&
       & gtk_radio_menu_item_new_with_label,&
       & gtk_separator_menu_item_new, gtk_tearoff_menu_item_new,&
       & gtk_widget_add_accelerator, gtk_widget_set_sensitive,&
       & gtk_label_new, gtk_label_set_markup, gtk_container_add, &
       & gtk_widget_set_tooltip_text, GTK_PACK_DIRECTION_LTR, &
       & TRUE, FALSE, g_signal_connect

  use g, only: g_slist_length, g_slist_nth, g_slist_nth_data

  use gtk_hl_accelerator

  implicit none

contains

  !+
  function hl_gtk_menu_new(orientation) result(menu)

    type(c_ptr) :: menu
    integer(kind=c_int), intent(in), optional :: orientation

    ! Menu initializer (mainly for consistency)
    !
    ! ORIENTATION: integer: optional: Whether to lay out the top level
    ! 		horizontaly or vertically.
    !-

    integer(kind=c_int) :: orient
    if (present(orientation)) then
       orient= orientation
    else
       orient = GTK_PACK_DIRECTION_LTR
    end if

    menu = gtk_menu_bar_new()
    call gtk_menu_bar_set_pack_direction (menu, orient)

  end function hl_gtk_menu_new

  !+
  function hl_gtk_menu_submenu_new(menu, label, tooltip, pos, is_markup) &
       & result(submenu)

    type(c_ptr) :: submenu
    type(c_ptr) :: menu
    character(kind=c_char), dimension(*), intent(in) :: label
    character(kind=c_char), dimension(*), intent(in), optional :: tooltip
    integer(kind=c_int), intent(in), optional :: pos
    integer(kind=c_int), intent(in), optional :: is_markup

    ! Make a submenu node
    !
    ! MENU: c_ptr: required:  The parent of the submenu
    ! LABEL: string: required: The label of the submenu
    ! TOOLTIP: string: optional: A tooltip for the submenu.
    ! POS: integer: optional: The position at which to insert the item
    ! 		(omit to append)
    ! IS_MARKUP: boolean: optional: Set this to TRUE if the label contains
    ! 		Pango markup.
    !-

    type(c_ptr) :: item, label_w
    logical :: markup

    if (present(is_markup)) then
       markup=c_f_logical(is_markup)
    else
       markup=.false.
    end if

    ! Create a menu item
    if (markup) then
       item = gtk_menu_item_new()
       label_w = gtk_label_new(label)
       call gtk_label_set_markup(label_w, label)
       call gtk_container_add(item, label_w)
    else
       item = gtk_menu_item_new_with_label(label)
    end if

    ! Create a submenu and attach it to the item
    submenu = gtk_menu_new()
    call  gtk_menu_item_set_submenu(item, submenu)

    ! Insert it to the parent
    if (present(pos)) then
       call gtk_menu_shell_insert(menu, item, pos)
    else
       call gtk_menu_shell_append(menu, item)
    end if

    if (present(tooltip)) call gtk_widget_set_tooltip_text(item, tooltip)

  end function hl_gtk_menu_submenu_new

  !+
  function hl_gtk_menu_item_new(menu, label, activate, data, tooltip, &
       & pos, tearoff, sensitive, accel_key, accel_mods, accel_group, &
       & accel_flags, is_markup) result(item)

    type(c_ptr) ::  item
    type(c_ptr) :: menu
    character(kind=c_char), dimension(*), intent(in), optional :: label
    type(c_funptr), optional :: activate
    type(c_ptr), optional :: data
    character(kind=c_char), dimension(*), intent(in), optional :: tooltip
    integer(kind=c_int), intent(in), optional :: pos
    integer(kind=c_int), intent(in), optional :: tearoff, sensitive
    character(kind=c_char), dimension(*), optional, intent(in) :: accel_key
    integer(kind=c_int), optional, intent(in) :: accel_mods, accel_flags
    type(c_ptr), optional, intent(in) :: accel_group
    integer(kind=c_int), intent(in), optional :: is_markup

    ! Make a menu item or separator
    !
    ! MENU: c_ptr: required: The parent menu.
    ! LABEL: string: optional: The label for the menu, if absent then insert
    ! 		a separator.
    ! ACTIVATE: c_funptr: optional: The callback function for the
    ! 		activate signal
    ! DATA: c_ptr: optional: Data to pass to the callback.
    ! TOOLTIP: string: optional: A tooltip for the menu item.
    ! POS: integer: optional: The position at which to insert the item
    ! 		(omit to append)
    ! TEAROFF: boolean: optional: Set to TRUE to make a tearoff point.
    ! SENSITIVE: boolean: optional: Set to FALSE to make the widget start in an
    ! 		insensitive state.
    ! ACCEL_KEY: string: optional: Set to the character value or code of a
    ! 		key to use as an accelerator.
    ! ACCEL_MODS: c_int: optional: Set to the modifiers for the accelerator.
    ! 		(If not given then GTK_CONTROL_MASK is assumed).
    ! ACCEL_GROUP: c_ptr: optional: The accelerator group to which the
    ! 		accelerator is attached, must have been added to the top-level
    ! 		window.
    ! ACCEL_FLAGS: c_int: optional: Flags for the accelerator, if not present
    ! 		then GTK_ACCEL_VISIBLE, is used (to hide the accelerator,
    ! 		use ACCEL_FLAGS=0).
    ! IS_MARKUP: boolean: optional: Set this to TRUE if the label contains
    ! 		Pango markup.
    !-

    integer(kind=c_int) :: istear
    logical :: markup
    type(c_ptr) :: label_w, junk

    if (present(tearoff)) then
       istear = tearoff
    else
       istear = FALSE
    end if

    if (present(is_markup)) then
       markup=c_f_logical(is_markup)
    else
       markup=.false.
    end if

    ! Create the menu item
    if (present(label)) then
       if (markup) then
          item=gtk_menu_item_new()
          label_w=gtk_label_new(label)
          call gtk_label_set_markup(label_w, label)
          call gtk_container_add(item,label_w)
       else
          item = gtk_menu_item_new_with_label(label)
       end if
    else if (istear == TRUE) then
       item = gtk_tearoff_menu_item_new()
    else
       item = gtk_separator_menu_item_new()
    end if

    ! Insert it to the parent
    if (present(pos)) then
       call gtk_menu_shell_insert(menu, item, pos)
    else
       call gtk_menu_shell_append(menu, item)
    end if

    ! If present, connect the callback
    if (present(activate)) then
       if (.not. present(label)) then
          write(error_unit, *) &
               & "HL_GTK_MENU_ITEM: Cannot connect a callback to a separator"
          return
       end if

       if (present(data)) then
          call g_signal_connect(item, "activate"//c_null_char, activate, data)
       else
          call g_signal_connect(item, "activate"//c_null_char, activate)
       end if

       ! An accelerator
       if (present(accel_key) .and. present(accel_group)) &
            & call hl_gtk_widget_add_accelerator(item, "activate"//c_null_char, &
            & accel_group, accel_key, accel_mods, accel_flags)
    end if

    ! Attach a tooltip
    if (present(tooltip)) call gtk_widget_set_tooltip_text(item, tooltip)

    ! sensitive?
    if (present(sensitive)) call gtk_widget_set_sensitive(item, sensitive)

  end function hl_gtk_menu_item_new

  !+
  function hl_gtk_check_menu_item_new(menu, label, toggled, data, &
       & tooltip, pos, initial_state, sensitive, is_markup)  result(item)

    type(c_ptr) ::  item
    type(c_ptr) :: menu
    character(kind=c_char), dimension(*), intent(in) :: label
    type(c_funptr), optional :: toggled
    type(c_ptr), optional :: data
    character(kind=c_char), dimension(*), intent(in), optional :: tooltip
    integer(kind=c_int), optional, intent(in) :: pos
    integer(kind=c_int), optional, intent(in) :: initial_state
    integer(kind=c_int), optional, intent(in) :: sensitive, is_markup

    ! Make a menu item or separator
    !
    ! MENU: c_ptr: required: The parent menu.
    ! LABEL: string: required: The label for the menu.
    ! TOGGLED: c_funptr: optional: The callback function for the
    ! 		"toggled" signal
    ! DATA: c_ptr: optional: Data to pass to the callback.
    ! TOOLTIP: string: optional: A tooltip for the menu item.
    ! POS: integer: optional: The position at which to insert the item
    ! 		(omit to append)
    ! INITIAL_STATE: boolean: optional: Whether the item is initially selected.
    ! SENSITIVE: boolean: optional: Set to FALSE to make the widget start in an
    ! 		insensitive state.
    ! IS_MARKUP: boolean: optional: Set this to TRUE if the label contains
    ! 		Pango markup.
    !-

    type(c_ptr) :: label_w
    logical :: markup

    if (present(is_markup)) then
       markup = c_f_logical(is_markup)
    else
       markup = .false.
    end if

    ! Create the menu item
    if (markup) then
       item = gtk_check_menu_item_new()
       label_w=gtk_label_new(c_null_char)
       call gtk_label_set_markup(label_w, label)
       call gtk_container_add(item, label_w)
    else
       item = gtk_check_menu_item_new_with_label(label)
    end if
    
    ! Insert it to the parent
    if (present(pos)) then
       call gtk_menu_shell_insert(menu, item, pos)
    else
       call gtk_menu_shell_append(menu, item)
    end if

    ! Set the state
    if (present(initial_state)) &
         & call gtk_check_menu_item_set_active(item, initial_state)

    ! If present, connect the callback
    if (present(toggled)) then
       if (present(data)) then
          call g_signal_connect(item, "toggled"//c_null_char, toggled, data)
       else
          call g_signal_connect(item, "toggled"//c_null_char, toggled)
       end if
    end if

    ! Attach a tooltip
    if (present(tooltip)) call gtk_widget_set_tooltip_text(item, tooltip)
    ! sensitive?
    if (present(sensitive)) call gtk_widget_set_sensitive(item, sensitive)
  end function hl_gtk_check_menu_item_new

  !+
  function hl_gtk_radio_menu_item_new(group, menu, label, toggled, data, &
       & tooltip, pos, sensitive, is_markup)  result(item)

    type(c_ptr) :: item
    type(c_ptr), intent(inout) ::  group
    type(c_ptr), intent(in) :: menu
    character(kind=c_char), dimension(*), intent(in) :: label
    type(c_funptr), optional :: toggled
    type(c_ptr), optional :: data
    character(kind=c_char), dimension(*), intent(in), optional :: tooltip
    integer(kind=c_int), optional, intent(in) :: pos
    integer(kind=c_int), optional, intent(in) :: sensitive, is_markup

    ! Make a menu item or separator
    !
    ! GROUP: c_ptr: required: The group for the radio item (C_NULL_PTR for a
    ! 		new group).
    ! MENU: c_ptr: required: The parent menu.
    ! LABEL: string: required: The label for the menu.
    ! TOGGLED: c_funptr: optional: The callback function for the
    ! 		"toggled" signal
    ! DATA: c_ptr: optional: Data to pass to the callback.
    ! TOOLTIP: string: optional: A tooltip for the menu item.
    ! POS: integer: optional: The position at which to insert the item
    ! 		(omit to append)
    ! SENSITIVE: boolean: optional: Set to FALSE to make the widget start in an
    ! 		insensitive state.
    ! IS_MARKUP: boolean: optional: Set this to TRUE if the label contains
    ! 		Pango markup.
    !-

    type(c_ptr) :: label_w
    logical :: markup

    if (present(is_markup)) then
       markup = c_f_logical(is_markup)
    else
       markup = .false.
    end if

    ! Create the menu item
    if (markup) then
       item = gtk_radio_menu_item_new(group)
       label_w=gtk_label_new(c_null_char)
       call gtk_label_set_markup(label_w, label)
       call gtk_container_add(item, label_w)
    else
       item = gtk_radio_menu_item_new_with_label(group, label)
    end if
    group = gtk_radio_menu_item_get_group(item)

    ! Insert it to the parent
    if (present(pos)) then
       call gtk_menu_shell_insert(menu, item, pos)
    else
       call gtk_menu_shell_append(menu, item)
    end if

    ! If present, connect the callback
    if (present(toggled)) then
       if (present(data)) then
          call g_signal_connect(item, "toggled"//c_null_char, toggled, data)
       else
          call g_signal_connect(item, "toggled"//c_null_char, toggled)
       end if
    end if

    ! Attach a tooltip
    if (present(tooltip)) call gtk_widget_set_tooltip_text(item, tooltip)
    ! sensitive?
    if (present(sensitive)) call gtk_widget_set_sensitive(item, sensitive)

  end function hl_gtk_radio_menu_item_new

  !+
  subroutine hl_gtk_radio_menu_group_set_select(group, index)
    type(c_ptr), intent(in) :: group
    integer(kind=c_int), intent(in) :: index

    ! Set the indexth button of a radio menu group
    !
    ! GROUP: c_ptr: required: The group of the last button added to
    ! 		the radio menu
    ! INDEX: integer: required: The index of the button to set
    ! 		(starting from the first as 0).
    !-

    integer(kind=c_int) :: nbuts
    type(c_ptr) :: datan

    nbuts = g_slist_length(group)

    ! Note that GROUP actually points to the last button added and to the
    ! group of the next to last & so on

    datan= g_slist_nth_data(group, nbuts-index-1)
    call gtk_check_menu_item_set_active(datan, TRUE)

  end subroutine hl_gtk_radio_menu_group_set_select

  !+
  subroutine hl_gtk_menu_item_set_label_markup(item, label)
    type(c_ptr) :: item
    character(kind=c_char), dimension(*), intent(in) :: label

    ! Set a markup label on a menu item
    !
    ! ITEM: c_ptr: required: The menu item to relabel
    ! LABEL: string: required: The string (with Pango markup) to apply.
    !
    ! Normally if the label does not need Pango markup, then
    ! gtk_menu_item_set_label can be used.
    !-

    call hl_gtk_bin_set_label_markup(item, label)

  end subroutine hl_gtk_menu_item_set_label_markup
end module gtk_hl_menu
