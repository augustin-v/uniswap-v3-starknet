#[cfg(test)]
mod contract_tests {
    mod pool_contract_tests {
        mod burn_tests;
        mod mint_tests;
        mod swap_tests;
    }
    mod factory_tests;
    mod position_tests;
    mod quoter_tests;
    mod tick_bitmap_tests;
    mod tick_tests;
    mod utils;
}
#[cfg(test)]
mod math_tests {
    mod fullmath_test;
    mod liquidity_math_test;
    mod sqrtprice_math_test;
    mod swap_math_tests;
    mod tick_math_test;
    mod number {
        mod fixed_point_test;
    }
}

