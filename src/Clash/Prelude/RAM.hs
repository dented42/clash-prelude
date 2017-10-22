{-|
Copyright  :  (C) 2015-2016, University of Twente,
                  2017     , Google Inc.
License    :  BSD2 (see the file LICENSE)
Maintainer :  Christiaan Baaij <christiaan.baaij@gmail.com>

RAM primitives with a combinational read port.
-}

{-# LANGUAGE AllowAmbiguousTypes #-}
{-# LANGUAGE BangPatterns        #-}
{-# LANGUAGE CPP                 #-}
{-# LANGUAGE DataKinds           #-}
{-# LANGUAGE FlexibleContexts    #-}
{-# LANGUAGE MagicHash           #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE TypeApplications    #-}
{-# LANGUAGE TypeFamilies        #-}
{-# LANGUAGE TypeOperators       #-}

{-# LANGUAGE Safe #-}

{-# OPTIONS_HADDOCK show-extensions #-}

module Clash.Prelude.RAM
  ( -- * RAM synchronised to an arbitrary clock
    asyncRam
  , asyncRamPow2
  )
where

import           GHC.TypeLits         (KnownNat)
import           GHC.Stack            (HasCallStack, withFrozenCallStack)

import qualified Clash.Explicit.RAM   as E
import           Clash.Promoted.Nat   (SNat)
import           Clash.Signal
import           Clash.Sized.Unsigned (Unsigned)


-- | Create a RAM with space for @n@ elements.
--
-- * __NB__: Initial content of the RAM is 'undefined'
--
-- Additional helpful information:
--
-- * See "Clash.Prelude.BlockRam#usingrams" for more information on how to use a
-- RAM.
asyncRam
  :: forall gated domain addr n a
   . (Enum addr, HasClock domain gated, HasCallStack)
  => SNat n
  -- ^ Size @n@ of the RAM
  -> Signal domain addr
  -- ^ Read address @r@
  -> Signal domain (Maybe (addr, a))
   -- ^ (write address @w@, value to write)
  -> Signal domain a
   -- ^ Value of the @RAM@ at address @r@
asyncRam = \sz rd wrM -> withFrozenCallStack
  (E.asyncRam (hasClock @gated) (hasClock @gated) sz rd wrM)
{-# INLINE asyncRam #-}

-- | Create a RAM with space for 2^@n@ elements
--
-- * __NB__: Initial content of the RAM is 'undefined'
--
-- Additional helpful information:
--
-- * See "Clash.Prelude.BlockRam#usingrams" for more information on how to use a
-- RAM.
asyncRamPow2
  :: forall gated domain n a
   . (KnownNat n, HasClock domain gated, HasCallStack)
  => Signal domain (Unsigned n)
  -- ^ Read address @r@
  -> Signal domain (Maybe (Unsigned n, a))
  -- ^ (write address @w@, value to write)
  -> Signal domain a
  -- ^ Value of the @RAM@ at address @r@
asyncRamPow2 = \rd wrM -> withFrozenCallStack
  (E.asyncRamPow2 (hasClock @gated) (hasClock @gated) rd wrM)
{-# INLINE asyncRamPow2 #-}
