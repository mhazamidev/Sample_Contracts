// SPDX-License-Identifier: MIT
pragma solidity >=0.8.15;

/*
    How to Signature-Verification

    1. Signin (off-chain)
        1. Create message to sign
        2. Hash the message
        3. Sign the hash (off chain, keep your private key secret)

    2. Verify (on-chain)
        1. Recreate hash from the orginal message
        2. Recover signer from signature adn hash
        3. Compare "recovered signer" to "claimed signer"

*/

contract VerifySignature {
    function getMessageHash(
        string memory _message
    ) public pure returns (bytes32 hash) {
        hash = keccak256(abi.encodePacked(_message));
    }

    function getETHSignedHash(
        bytes32 hash
    ) public pure returns (bytes32 ethSignedHash) {
        ethSignedHash = keccak256(
            abi.encodePacked("\x19Ethereum Signed Message:\n32", hash)
        );
    }

    function verify(
        address _claimedSigner,
        string memory _message,
        bytes memory signature
    ) public pure returns (bool) {
        bytes32 msgHash = getMessageHash(_message);
        bytes32 ethSignedHash = getETHSignedHash(msgHash);

        return recoverSigner(ethSignedHash, signature) == _claimedSigner;
    }

    // recognize real recovered signer
    function recoverSigner(
        bytes32 _ethSignedHash,
        bytes memory _signature
    ) public pure returns (address _recoverSigner) {
        // ECDSA algoritms
        // 65 bytes
        // r: first 32 bytes, after the length perfic
        // s: secind 32 bytes
        // v: final byte (first byte of the next 32 bytes)
        (bytes32 r, bytes32 s, uint8 v) = splitSignature(_signature);

        _recoverSigner = ecrecover(_ethSignedHash, v, r, s);
    }

    function splitSignature(
        bytes memory _signature
    ) public pure returns (bytes32 r, bytes32 s, uint8 v) {
        require(_signature.length == 65, "invalid signature");

        assembly {
            r := mload(add(_signature, 32))
            s := mload(add(_signature, 64))
            v := byte(0, mload(add(_signature, 96)))
        }
    }
}
