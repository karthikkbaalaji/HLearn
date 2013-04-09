{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE UndecidableInstances #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE BangPatterns #-}
{-# LANGUAGE TypeSynonymInstances #-}
{-# LANGUAGE TypeFamilies #-}

module HLearn.Models.Distributions.Univariate.Uniform
    where

import HLearn.Algebra
import HLearn.Models.Distributions.Common
import HLearn.Models.Distributions.Gnuplot

-------------------------------------------------------------------------------
-- data types

data Uniform' datapoint = Uniform'
    { mindp :: datapoint
    , maxdp :: datapoint
    }
    deriving (Read,Show,Eq,Ord)

type Uniform datapoint = RegSG2Group (Uniform' datapoint)

range :: (Num datapoint) => Uniform' datapoint -> datapoint
range dist = maxdp dist-mindp dist

-------------------------------------------------------------------------------
-- algebra

instance (Ord datapoint) => Semigroup (Uniform' datapoint) where
    u1 <> u2 = Uniform'
        { maxdp = max (maxdp u1) (maxdp u2)
        , mindp = min (mindp u1) (mindp u2)
        }

-------------------------------------------------------------------------------
-- training

instance ModelParams (Uniform datapoint) where
    type Params (Uniform datapoint) = NoParams
    getparams _ = NoParams
    
instance (Ord datapoint) => HomTrainer (Uniform datapoint) where
    type Datapoint (Uniform datapoint) = datapoint 
    train1dp' _ dp = SGJust $ Uniform' dp dp

-------------------------------------------------------------------------------
-- distribution

instance (Ord datapoint, Fractional datapoint) => PDF (Uniform datapoint) datapoint datapoint where
    pdf (SGJust dist) dp = if dp>=mindp dist && dp<=maxdp dist
        then 1/(range dist)
        else 0

instance 
    ( PlottableDataPoint datapoint
    , Fractional datapoint
    , Show datapoint
    , Ord datapoint
    ) => PlottableDistribution (Uniform datapoint) datapoint datapoint where    
    minx (SGJust dist) = (mindp dist - range dist * 0.2)
    maxx (SGJust dist) = (maxdp dist + range dist * 0.2)