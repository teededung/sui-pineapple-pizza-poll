/// Module: voting
module voting::pineapple_pizza_poll;

use std::string::{Self, String};
use sui::event;
use sui::vec_set::{Self, VecSet};

// === Errors ===
const E_ALREADY_VOTED: u64 = 1;

// === Events ===
public struct TopicEvent has copy, drop {
    topic: String,
}

public struct VotesEvent has copy, drop {
    yes: u64,
    no: u64,
}

public struct LeaderEvent has copy, drop {
    message: String,
}

// === Structs ===
/// Global shared voting poll
public struct PizzaPoll has key {
    id: UID,
    topic: String,
    yes_votes: u64,
    no_votes: u64,
    voters: VecSet<address>,
}

// === Package Initialization ===
fun init(ctx: &mut TxContext) {
    let poll = PizzaPoll {
        id: object::new(ctx),
        topic: string::utf8(b"Does pineapple belong on pizza?"),
        yes_votes: 0,
        no_votes: 0,
        voters: vec_set::empty(),
    };
    transfer::share_object(poll);
}

// === Voting Functions ===
entry fun vote_yes(poll: &mut PizzaPoll, ctx: &TxContext) {
    let sender = tx_context::sender(ctx);
    assert!(!vec_set::contains(&poll.voters, &sender), E_ALREADY_VOTED);

    vec_set::insert(&mut poll.voters, sender);
    poll.yes_votes = poll.yes_votes + 1;
}

entry fun vote_no(poll: &mut PizzaPoll, ctx: &TxContext) {
    let sender = tx_context::sender(ctx);
    assert!(!vec_set::contains(&poll.voters, &sender), E_ALREADY_VOTED);

    vec_set::insert(&mut poll.voters, sender);
    poll.no_votes = poll.no_votes + 1;
}

// === View Functions (emit events - easy to view in CLI) ===
/// emit event = cách hiển thị kết quả cho người dùng/frontend/CLI một cách đơn giản và rõ ràng
entry fun emit_topic(poll: &PizzaPoll) {
    event::emit(TopicEvent { topic: poll.topic });
}

entry fun emit_votes(poll: &PizzaPoll) {
    event::emit(VotesEvent {
        yes: poll.yes_votes,
        no: poll.no_votes,
    });
}

entry fun emit_leader(poll: &PizzaPoll) {
    let (yes, no) = (poll.yes_votes, poll.no_votes);
    let message = if (yes > no) {
        string::utf8(b"Pineapple lovers are winning! 🍍🍕")
    } else if (no > yes) {
        string::utf8(b"Pizza purists are dominating! ❌🍍")
    } else {
        string::utf8(b"It's a perfect tie! The great debate continues...")
    };

    event::emit(LeaderEvent { message });
}
