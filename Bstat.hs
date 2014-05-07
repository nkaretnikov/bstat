{- bstat: report battery status information.
   Copyright 2014 Nikita Karetnikov <nikita@karetnikov.org>

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.
-}

module Main where

import System.IO
import Data.Char

main = do
  let dropNewline      = concat . lines
      readBatInfo path = readFile path >>= return . map toLower . dropNewline
  status        <-
    readBatInfo "/sys/devices/virtual/power_supply/yeeloong-bat/status"
  capacityLevel <-
    readBatInfo "/sys/devices/virtual/power_supply/yeeloong-bat/capacity_level"

  let readInteger path = readFile path
                     >>= return . (read :: String -> Integer)
  chargeFull <-
    readInteger "/sys/devices/virtual/power_supply/yeeloong-bat/charge_full"
  chargeNow  <-
    readInteger "/sys/devices/virtual/power_supply/yeeloong-bat/charge_now"

  putStrLn $ "Status: " ++ status
  putStrLn $ "Capacity level: " ++ capacityLevel
  putStrLn $ "Charge: " ++ show (chargeNow * 100 `div` chargeFull) ++ "%"
