module MyModule::MicroDonation {
    use aptos_framework::signer;
    use aptos_framework::coin;
    use aptos_framework::aptos_coin::AptosCoin;

    /// Struct representing a donation recipient's account.
    struct DonationAccount has store, key {
        total_received: u64,    // Total micro donations received
        donation_count: u64,    // Number of individual donations
    }

    /// Function to register as a donation recipient.
    public fun register_recipient(recipient: &signer) {
        let donation_account = DonationAccount {
            total_received: 0,
            donation_count: 0,
        };
        move_to(recipient, donation_account);
    }

    /// Function to make a micro donation to a recipient.
    public fun donate(donor: &signer, recipient_addr: address, amount: u64) acquires DonationAccount {
        // Ensure recipient is registered
        assert!(exists<DonationAccount>(recipient_addr), 1);
        
        let donation_account = borrow_global_mut<DonationAccount>(recipient_addr);
        
        // Transfer the micro donation from donor to recipient
        let donation = coin::withdraw<AptosCoin>(donor, amount);
        coin::deposit<AptosCoin>(recipient_addr, donation);
        
        // Update donation statistics
        donation_account.total_received = donation_account.total_received + amount;
        donation_account.donation_count = donation_account.donation_count + 1;
    }
}