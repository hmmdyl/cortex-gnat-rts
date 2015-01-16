--  Copyright (C) Simon Wright <simon@pushface.org>

--  This unit is free software; you can redistribute it and/or modify it
--  as you wish. This unit is distributed in the hope that it will be
--  useful, but WITHOUT ANY WARRANTY; without even the implied warranty
--  of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

--  This is part of the demonstration of the CMSIS_OS/FreeRTOS-based
--  Ravenscar-style runtime system.

with Ada.Real_Time;
with STM32F429I_Discovery.LEDs;
with System;

package body LEDs is

   task type LED (The_LED       : STM32F429I_Discovery.LEDs.LED;
                  Period_Millis : Positive) is
      pragma Storage_Size (512 + 256);
   end LED;

   task Actor is
      pragma Storage_Size (512 + 256);
      pragma Priority (System.Default_Priority + 1);
   end Actor;

   protected Guard is
      entry Action (The_LED : out STM32F429I_Discovery.LEDs.LED);
      procedure Toggle (The_LED : STM32F429I_Discovery.LEDs.LED);
   private
      Tasked : Boolean := False;
      L      : STM32F429I_Discovery.LEDs.LED;
   end Guard;

   task body LED is
      Next : Ada.Real_Time.Time := Ada.Real_Time.Clock;
      use type Ada.Real_Time.Time;
   begin
      loop
         Guard.Toggle (The_LED);
         Next := Next + Ada.Real_Time.Milliseconds (Period_Millis);
         delay until Next;
      end loop;
   end LED;

   task body Actor is
      The_LED : STM32F429I_Discovery.LEDs.LED;
   begin
      loop
         Guard.Action (The_LED);
         STM32F429I_Discovery.LEDs.Toggle (The_LED);
      end loop;
   end Actor;

   protected body Guard is
      entry Action (The_LED : out STM32F429I_Discovery.LEDs.LED) when Tasked is
      begin
         Tasked := False;
         The_LED := L;
      end Action;
      procedure Toggle (The_LED : STM32F429I_Discovery.LEDs.LED) is
      begin
         L := The_LED;
         Tasked := True;
      end Toggle;
   end Guard;

   Red   : LED (STM32F429I_Discovery.LEDs.Red,   1000);
   Green : LED (STM32F429I_Discovery.LEDs.Green, 125);

end LEDs;
