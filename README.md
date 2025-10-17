Counter Smart Contract

Simple State Management on Stacks using Clarity & Clarinet

 Overview

The Counter Smart Contract is a minimal, educational, and production-ready example of a Clarity smart contract running on the Stacks blockchain.
It showcases the fundamental logic behind state storage, mutation, and access control using the Clarinet development framework.

This project allows any user to:

Increment or decrement a shared counter

Increment by a custom value

Admin-only reset or decrement functions

View real-time counter information

Transfer admin rights securely

 Features
Function	Description
increment	Increases the counter by 1
increment-by	Increases the counter by a custom amount
decrement	Decreases the counter by 1 (if greater than 0)
decrement-by	Decreases counter by custom amount (admin only)
reset	Resets counter to 0 (admin only)
transfer-admin	Transfers admin privileges
get-counter	Reads the current counter value
get-info	Displays counter, admin, and block height

 Smart Contract Details

Contract Name: counter

Language: Clarity

Framework: Clarinet

Network: Stacks (testnet/localnet)

File: contracts/counter.clar
