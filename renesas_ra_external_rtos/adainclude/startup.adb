--  Copyright (C) 2016-2021 Free Software Foundation, Inc.
--
--  This file is part of the Cortex GNAT RTS project. This file is
--  free software; you can redistribute it and/or modify it under
--  terms of the GNU General Public License as published by the Free
--  Software Foundation; either version 3, or (at your option) any
--  later version. This file is distributed in the hope that it will
--  be useful, but WITHOUT ANY WARRANTY; without even the implied
--  warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
--
--  As a special exception under Section 7 of GPL version 3, you are
--  granted additional permissions described in the GCC Runtime
--  Library Exception, version 3.1, as published by the Free Software
--  Foundation.
--
--  You should have received a copy of the GNU General Public License
--  and a copy of the GCC Runtime Library Exception along with this
--  program; see the files COPYING3 and COPYING.RUNTIME respectively.
--  If not, see <http://www.gnu.org/licenses/>.

--  with Interfaces;
--  with System.Machine_Code;
--  with System.Parameters;
--  with System.Storage_Elements;

--  For environment task creation
with Environment_Task;
with System.FreeRTOS.Tasks;

package body Startup is

   --  Program_Initialization is the program entry point.
   procedure Program_Initialization
   with
     Export,
     Convention => Ada,
     External_Name => "program_initialization",
     No_Return;

   --  If the link includes a symbol _default_initial_stack,
   --  use this as the storage size: otherwise, use 1024.
   --
   --  Used in Set_Up_Heap, but declared here because the argument for
   --  pragma "Weak_External" must be a library-level entity.
   --  Default_Initial_Stack : constant System.Parameters.Size_Type
   --  with
   --    Import,
   --    Convention => Ada,
   --    External_Name => "_default_initial_stack";
   --  pragma Weak_External (Default_Initial_Stack);

   procedure Program_Initialization is
   begin

      Environment_Task.Create;

      --  Start the scheduler, which will run the environment task to
      --  perform elaboration and then execute the Ada main program.
      System.FreeRTOS.Tasks.Start_Scheduler;
   end Program_Initialization;

end Startup;
